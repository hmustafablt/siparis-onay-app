import 'package:flutter/material.dart';
import 'order_list_screen.dart';
import 'approved_orders_screen.dart';
import 'profile_screen.dart';
import 'canceled_orders_screen.dart'; // Yeni ekranı import et

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OrderListScreen(), // Bekleyenler
    ApprovedOrdersScreen(), // Onaylananlar
    CanceledOrdersScreen(), // İptal Edilenler
    ProfileScreen(), // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Siparişler'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Onaylılar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'İptal Edilenler',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        type: BottomNavigationBarType.fixed, // 4+ item için fixed tipi önerilir
      ),
    );
  }
}
