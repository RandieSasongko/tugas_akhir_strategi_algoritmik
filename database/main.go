package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/gorilla/mux"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Barang struct {
	ID     uint    `gorm:"primaryKey" json:"id"`
	Nama   string  `json:"nama"`
	Harga  int     `json:"harga"`
	Berat  float64 `json:"berat"`
	Satuan string  `json:"satuan"`
}

var db *gorm.DB

func main() {
	var err error

	// Ganti sesuai koneksi MySQL kamu
	dsn := "root@tcp(127.0.0.1:3306)/tugas_akhir_strategi_algoritmik?charset=utf8mb4&parseTime=True&loc=Local"
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Gagal koneksi MySQL:", err)
	}

	// Migrasi model
	if err := db.AutoMigrate(&Barang{}); err != nil {
		log.Fatal("Gagal migrate:", err)
	}

	// Seed jika kosong
	var count int64
	db.Model(&Barang{}).Count(&count)
	if count == 0 {
		seedData()
	}

	// Routing dengan Gorilla Mux
	r := mux.NewRouter()

	r.HandleFunc("/barang", getAllBarang).Methods("GET")
	r.HandleFunc("/barang/{id}", getBarang).Methods("GET")
	r.HandleFunc("/barang", createBarang).Methods("POST")
	r.HandleFunc("/barang/{id}", updateBarang).Methods("PUT")
	r.HandleFunc("/barang/{id}", deleteBarang).Methods("DELETE")

	fmt.Println("Server running at http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", r))
}

// Get all barang
func getAllBarang(w http.ResponseWriter, r *http.Request) {
	var barangs []Barang
	db.Find(&barangs)
	json.NewEncoder(w).Encode(barangs)
}

// Get one barang
func getBarang(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	var barang Barang
	if err := db.First(&barang, id).Error; err != nil {
		http.NotFound(w, r)
		return
	}
	json.NewEncoder(w).Encode(barang)
}

// Create new barang
func createBarang(w http.ResponseWriter, r *http.Request) {
	var barang Barang
	if err := json.NewDecoder(r.Body).Decode(&barang); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	db.Create(&barang)
	json.NewEncoder(w).Encode(barang)
}

// Update barang
func updateBarang(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	var barang Barang
	if err := db.First(&barang, id).Error; err != nil {
		http.NotFound(w, r)
		return
	}
	json.NewDecoder(r.Body).Decode(&barang)
	db.Save(&barang)
	json.NewEncoder(w).Encode(barang)
}

// Delete barang
func deleteBarang(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	var barang Barang
	if err := db.Delete(&barang, id).Error; err != nil {
		http.Error(w, "Gagal hapus data", http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(map[string]string{"message": "Barang dihapus"})
}

// Seed dari CSV
func seedData() {
	file, err := os.Open("data_barang_bahanMakanan.csv")
	if err != nil {
		log.Fatal("Gagal membuka file CSV:", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		log.Fatal("Gagal membaca CSV:", err)
	}

	for i, row := range records {
		if i == 0 {
			continue // skip header
		}

		harga, err := strconv.Atoi(row[2])
		if err != nil {
			log.Printf("Baris %d: Gagal konversi harga: %v", i+1, err)
			continue
		}

		berat, err := strconv.ParseFloat(row[3], 64)
		if err != nil {
			log.Printf("Baris %d: Gagal konversi berat: %v", i+1, err)
			continue
		}

		db.Create(&Barang{
			Nama:   row[1],
			Harga:  harga,
			Berat:  berat,
			Satuan: row[4], // Ambil satuan dari kolom ke-5
		})
	}
}
