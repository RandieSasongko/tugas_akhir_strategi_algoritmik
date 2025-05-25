import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greedy_application/app/routes/app_pages.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Randie Sasongko",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              "randie.sasongko08@mhs.mdp.ac.id",
              style: TextStyle(fontSize: 12),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "images/profile_default.jpg",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage("images/background_profile_default.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Color(0xFF07193F), size: 24),
            title: Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            onTap: () {
              Get.toNamed(Routes.DASHBOARD);
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory, color: Color(0xFF07193F), size: 24),
            title: Text(
              "Data Barang",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            onTap: () {
              Get.toNamed(Routes.BARANG);
            },
          ),
        ],
      ),
    );
  }
}
