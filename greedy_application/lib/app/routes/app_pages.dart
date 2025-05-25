import 'package:get/get.dart';

import 'package:greedy_application/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:greedy_application/app/modules/dashboard/view/dashboard_view.dart';

import 'package:greedy_application/app/modules/barang/bindings/barang_binding.dart';
import 'package:greedy_application/app/modules/barang/view/barang_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BARANG,
      page: () => BarangView(),
      binding: BarangBinding(),
    ),
  ];
}
