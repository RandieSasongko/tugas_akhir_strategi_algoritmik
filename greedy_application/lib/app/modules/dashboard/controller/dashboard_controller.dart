import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greedy_application/app/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  TextEditingController kapasitasController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  var isLoading = true.obs;

  var dataGreedy = {}.obs;
  var dataBarang = [].obs;
  var totalBarang = 0.obs;
  var totalBerat = 0.0.obs;

  var persen1 = 0.0.obs;
  var persen2 = 0.0.obs;
  var persen3 = 0.0.obs;
  var persen4 = 0.0.obs;
  var persen5 = 0.0.obs;

  var totalGreedyProfit = 0.0.obs;
  var totalGreedyWeight = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getBarang();
  }

  Future<void> getBarang() async {
    isLoading.value = true;

    var url = Uri.parse(
      ApiEndPoints.baseUrlApiLocal + ApiEndPoints.authEndPoints.getBarang,
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        dataBarang.value = data;
        totalBarang.value = data.length;

        // Hitung total berat dari data
        double beratTotal = 0.0;
        for (var item in data) {
          beratTotal += (item['berat'] ?? 0).toDouble();
        }
        totalBerat.value = beratTotal;

        print('Berhasil Mendapatkan Data Barang');
      } else {
        print('Failed to fetch data barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendGreedy() async {
    isLoading.value = true;

    final kapasitasText = kapasitasController.text.trim();
    final double kapasitas = double.tryParse(kapasitasText) ?? 0.0;

    // Buat map percentages dari ID barang dan input persen
    final Map<String, double> percentages = {};
    final List<double> persenList = [
      persen1.value,
      persen2.value,
      persen3.value,
      persen4.value,
      persen5.value,
    ];

    for (int i = 0; i < dataBarang.length && i < persenList.length; i++) {
      final barang = dataBarang[i];
      final id = barang['id'].toString();
      final persen = persenList[i];

      if (persen > 0) {
        percentages[id] = persen;
      }
    }

    final url = Uri.parse(
      ApiEndPoints.baseUrlGreedy +
          ApiEndPoints.authEndPoints.kanpsackFractional,
    );
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "capacity": kapasitas,
      "percentages": percentages,
    });

    print("📤 Mengirim data ke $url");
    print("🔍 Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody is Map<String, dynamic>) {
          dataGreedy.value = responseBody;
          totalGreedyProfit.value =
              (responseBody['total_value'] ?? 0).toDouble();
          totalGreedyWeight.value =
              (responseBody['total_weight'] ?? 0).toDouble();

          print("✅ Response tersimpan ke dataGreedy");
        } else {
          print("⚠️ Format response tidak sesuai. Bukan Map.");
        }
      } else {
        print('❌ Gagal mengambil data (Status: ${response.statusCode})');
        print('💬 Response body: ${response.body}');
      }
    } catch (e) {
      print('❗ Error saat mengirim request: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
