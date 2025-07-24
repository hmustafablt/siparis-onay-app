import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mbtest/screens/profil_screen.dart';

// Ekran importları (Controller'ın doğrudan UI widget'larını bilmesi gerekmez,
// ancak _pages listesi için referanslar burada tutulabilir veya View'da kalabilir)
import '../screens/order_list_screen.dart';
import '../screens/approved_orders_screen.dart';
import '../screens/canceled_orders_screen.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    OrderListScreen(), // Bekleyenler
    ApprovedOrdersScreen(), // Onaylananlar
    CanceledOrdersScreen(), // İptal Edilenler
    ProfileScreen(), //Profil Detay
  ];

  // Tab değiştiğinde çağrılacak metod
  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Controller başlatıldığında yapılacak işlemler (örneğin veri çekme)
    print('HomeController başlatıldı');
  }

  @override
  void onClose() {
    super.onClose();
    // Controller kapatıldığında (bellekten atıldığında) yapılacak temizlik işlemleri
    print('HomeController kapatıldı');
  }
}
