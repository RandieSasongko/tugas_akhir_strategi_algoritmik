import 'dart:convert';

import 'package:get/get.dart';
import 'package:greedy_application/app/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class BarangController extends GetxController {
  var dataBarang = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getBarang();
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
}
