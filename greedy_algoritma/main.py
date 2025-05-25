from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

# Konfigurasi database
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'tugas_akhir_strategi_algoritmik'
}

def fetch_items_from_db():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT `id`, `nama`, `berat`, `harga` FROM barangs")
    items = cursor.fetchall()
    cursor.close()
    conn.close()
    return items

@app.route('/fractional_knapsack', methods=['POST'])
def fractional_knapsack_api():
    try:
        data = request.get_json()
        capacity = float(data.get('capacity', 0))
        percentages = data.get('percentages', {})  # { "id": persen }

        if capacity <= 0:
            return jsonify({"error": "Kapasitas harus lebih besar dari 0"}), 400

        items = fetch_items_from_db()
        result = fractional_knapsack(items, capacity, percentages)

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

def fractional_knapsack(items, capacity, percentages):
    selected_items_map = {}
    total_weight = 0
    total_value = 0
    sisa_items = []

    # Hitung harga per kg
    for item in items:
        item['harga_per_kg'] = item['harga'] / item['berat']

    # Tahap 1: ambil berdasarkan persentase
    for item in items:
        item_id = str(item['id'])
        berat_diambil = 0

        if item_id in percentages:
            percent = percentages[item_id]
            target_weight = (percent / 100.0) * capacity
            berat_diambil = min(target_weight, item['berat'])
            harga_diambil = berat_diambil * item['harga_per_kg']

            # Simpan hasil
            selected_items_map[item['id']] = {
                "id": item['id'],
                "nama": item['nama'],
                "berat_diambil": berat_diambil,
                "harga_diambil": harga_diambil
            }

            total_weight += berat_diambil
            total_value += harga_diambil

        # Sisakan ke tahap greedy jika masih ada sisa
        sisa_berat = item['berat'] - berat_diambil
        if sisa_berat > 0:
            sisa_items.append({
                "id": item['id'],
                "nama": item['nama'],
                "berat": sisa_berat,
                "harga": sisa_berat * item['harga_per_kg'],  # harga sisa
                "harga_per_kg": item['harga_per_kg']
            })

    # Tahap 2: greedy berdasarkan sisa kapasitas
    remaining_capacity = capacity - total_weight
    if remaining_capacity > 0:
        sisa_items = sorted(sisa_items, key=lambda x: x['harga_per_kg'], reverse=True)

        for item in sisa_items:
            if remaining_capacity <= 0:
                break

            berat_terambil = min(remaining_capacity, item['berat'])
            harga_terambil = berat_terambil * item['harga_per_kg']

            if item['id'] not in selected_items_map:
                selected_items_map[item['id']] = {
                    "id": item['id'],
                    "nama": item['nama'],
                    "berat_diambil": 0.0,
                    "harga_diambil": 0.0
                }

            selected_items_map[item['id']]["berat_diambil"] += berat_terambil
            selected_items_map[item['id']]["harga_diambil"] += harga_terambil

            total_weight += berat_terambil
            total_value += harga_terambil
            remaining_capacity -= berat_terambil

    # Format hasil
    selected_items = []
    for item in selected_items_map.values():
        harga_per_kg = item["harga_diambil"] / item["berat_diambil"] if item["berat_diambil"] > 0 else 0
        selected_items.append({
            "id": item["id"],
            "nama": item["nama"],
            "berat_diambil": round(item["berat_diambil"], 3),
            "harga_diambil": round(item["harga_diambil"], 2),
            "harga_per_kg": round(harga_per_kg, 2)
        })

    return {
        "total_value": round(total_value, 2),
        "total_weight": round(total_weight, 3),
        "selected_items": selected_items
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
