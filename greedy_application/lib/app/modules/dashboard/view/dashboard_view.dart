import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greedy_application/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:greedy_application/widgets/navBar.dart';
import 'package:intl/intl.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Greedy Application",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 170, // Atur tinggi sesuai kebutuhan
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  children: [
                    Obx(
                      () => _dashboardCard(
                        "Total Barang",
                        "images/boxes.png",
                        controller.totalBarang.value.toString(),
                      ),
                    ),
                    Obx(
                      () => _dashboardCard(
                        "Total Berat (KG)",
                        "images/weight.png",
                        controller.totalBerat.value.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("images/knapsack.png", width: 34),
                  SizedBox(width: 8),
                  Text(
                    "Greedy",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text("Masukkan Kapasitas (KG) :"),
              SizedBox(height: 8),
              TextField(
                controller: controller.kapasitasController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.]?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: 'Masukkan Kapasitas',
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ExpansionTile(
                title: Text('Setting Barang', style: TextStyle(fontSize: 14)),
                children: <Widget>[
                  _slider("Beras Premium Cap Ikan PATIN ", controller.persen1),
                  _slider("Tepung Biang Fried Chicken", controller.persen2),
                  _slider("GULA ROSEBRAND", controller.persen3),
                  _slider(
                    "Susu Bubuk Brandenburger F10-NA",
                    controller.persen4,
                  ),
                  _slider(
                    "Daging Sapi Sengkel Shank Sapi Lokal",
                    controller.persen5,
                  ),
                ],
              ),

              // Text("Masukkan Type :"),
              // SizedBox(height: 8),
              // DropdownButtonFormField<String>(
              //   value:
              //       controller.typeController.text.isEmpty
              //           ? null
              //           : controller.typeController.text,
              //   items:
              //       ['profit', 'weight'].map((type) {
              //         return DropdownMenuItem(value: type, child: Text(type));
              //       }).toList(),
              //   onChanged: (value) {
              //     if (value != null) {
              //       controller.typeController.text = value;
              //     }
              //   },
              //   decoration: InputDecoration(border: OutlineInputBorder()),
              // ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.kapasitasController.clear();
                      controller.dataGreedy.clear();
                      controller.totalGreedyWeight.value = 0;
                      controller.totalGreedyProfit.value = 0;
                      controller.persen1.value = 0;
                      controller.persen2.value = 0;
                      controller.persen3.value = 0;
                      controller.persen4.value = 0;
                      controller.persen5.value = 0;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.red,
                      ),
                      width: 100,
                      padding: EdgeInsets.only(top: 14, bottom: 14),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.1,
                                ), // Bayangan soft
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4), // Bayangan jatuh ke bawah
                              ),
                            ],
                          ),
                          child: Text(
                            "Bersihkan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final kapasitasText =
                          controller.kapasitasController.text.trim();
                      final kapasitas = double.tryParse(kapasitasText) ?? 0;

                      if (kapasitas <= 0) {
                        Get.snackbar(
                          "Input tidak valid",
                          "Kapasitas harus lebih dari 0",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16),
                        );
                        return;
                      }
                      controller.sendGreedy();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.red),
                      ),
                      width: 100,
                      padding: EdgeInsets.only(top: 14, bottom: 14),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.1,
                                ), // Bayangan soft
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4), // Bayangan jatuh ke bawah
                              ),
                            ],
                          ),
                          child: Text(
                            "Process",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("images/result.png", width: 34),
                  SizedBox(width: 8),
                  Text(
                    "Hasil Greedy",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Obx(
                () => Text(
                  "Total Profit: Rp ${NumberFormat.decimalPattern('id_ID').format(controller.totalGreedyProfit.value)}",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Obx(
                () => Text(
                  "Total Berat : ${controller.totalGreedyWeight.value.toStringAsFixed(2)} KG",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Data Barang",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Obx(() {
                final processLog =
                    controller.dataGreedy['selected_items'] ?? [];

                if (processLog.isEmpty) {
                  return Text("Belum ada proses Greedy.");
                }

                return SizedBox(
                  height: 600,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: processLog.length,
                      itemBuilder: (context, index) {
                        final item = processLog[index];
                        final itemName = item['nama'] ?? 'Tidak diketahui';
                        final value = item['harga_diambil'] ?? 0;
                        final weight = item['berat_diambil'] ?? 0;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.zero, // agar padding tidak dobel
                            title: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Nama Barang: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: itemName ?? 'Tidak tersedia',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Harga Barang: ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Rp. " + value.toString(),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Berat Barang: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: weight.toString() + " KG",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slider(String title, RxDouble persen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title: ${persen.value.toStringAsFixed(1)}%",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Slider(
              value: persen.value,
              min: 0,
              max: 20,
              divisions: 20,
              label: "${persen.value.toInt()}%",
              activeColor: Colors.red,
              onChanged: (value) {
                persen.value = value;
              },
            ),
            Divider(height: 1, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String icon, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(color: Color(0xFF999999).withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(icon, width: 38, scale: 1),
                  const SizedBox(width: 5),
                  Text(
                    value,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
