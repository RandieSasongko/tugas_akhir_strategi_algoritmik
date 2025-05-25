import 'package:get/get.dart';
import 'package:greedy_application/app/modules/barang/controller/barang_controller.dart';

class BarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarangController>(() => BarangController());
  }
}
