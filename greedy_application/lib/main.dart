import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greedy_application/app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Greedy Application',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
