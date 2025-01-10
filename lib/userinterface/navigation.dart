import 'package:flutter/material.dart';
import 'package:frontend/userinterface/getbarang.dart';
import 'package:frontend/userinterface/getpelanggan.dart';
import 'package:frontend/userinterface/gettransaksi.dart';
import 'package:frontend/userinterface/home.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:solar_icons/solar_icons.dart';

class navigasi extends StatefulWidget {
  const navigasi({super.key});

  @override
  State<navigasi> createState() => _navigasiState();
}

class _navigasiState extends State<navigasi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: Home(),
            item: ItemConfig(
              inactiveIcon: Icon(Icons.home_rounded,
                  color: Color.fromARGB(255, 133, 169, 71)),
              icon: Icon(Icons.home),
              activeForegroundColor: Color.fromARGB(255, 18, 53, 36),
              title: "Beranda",
            ),
          ),
          PersistentTabConfig(
            screen: GetBarang(),
            item: ItemConfig(
              inactiveIcon: Icon(SolarIconsBold.cart_4,
                  color: Color.fromARGB(255, 133, 169, 71)),
              icon: Icon(SolarIconsBold.cart_4),
              activeForegroundColor: Color.fromARGB(255, 18, 53, 36),
              title: "Sayur",
            ),
          ),
          PersistentTabConfig(
            screen: GetTransaksi(),
            item: ItemConfig(
              inactiveIcon: Icon(Icons.receipt_long_rounded,
                  color: Color.fromARGB(255, 133, 169, 71)),
              icon: Icon(Icons.receipt_long_rounded),
              activeForegroundColor: Color.fromARGB(255, 18, 53, 36),
              title: "Transaksi",
            ),
          ),
          PersistentTabConfig(
            screen: GetPelanggan(),
            item: ItemConfig(
              inactiveIcon:
                  Icon(Icons.person, color: Color.fromARGB(255, 133, 169, 71)),
              icon: Icon(Icons.person),
              activeForegroundColor: Color.fromARGB(255, 18, 53, 36),
              title: "Pelanggan",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
