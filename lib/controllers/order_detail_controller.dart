import 'package:get/get.dart';
import 'package:flutter/material.dart'; // SnackBar için gerekli
import '../models/order.dart';
import '../services/order_repository.dart';

class OrderDetailController extends GetxController {
  // OrderRepository'nin instance'ını GetX'ten alıyoruz.
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // Bu ekranın göstereceği Order nesnesi
  // Get.arguments ile geçileceği için late olarak tanımlandı.
  late Order order;

  @override
  void onInit() {
    super.onInit();
    // Sayfaya geçerken gönderilen Order nesnesini al.
    // Eğer Order nesnesi geçilmezse veya tipi yanlışsa hata yönetimi yapılır.
    if (Get.arguments != null && Get.arguments is Order) {
      order = Get.arguments as Order;
      print('OrderDetailController başlatıldı. Sipariş ID: ${order.id}');
    } else {
      // Geçersiz veya eksik sipariş verisi durumunda geri dön ve hata mesajı göster.
      Get.back();
      Get.snackbar(
        'Hata',
        'Sipariş detayı yüklenemedi. Geçersiz veri.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Siparişi onaylama metodu
  void approveOrder() {
    _orderRepository.approveOrder(order); // OrderRepository'deki metodu çağır
    Get.back(); // Detay ekranından geri dön

    // Başarı mesajı göster
    Get.snackbar(
      'Başarılı',
      '${order.customer.value} siparişi onaylandı.', // Reaktif değere .value ile erişim
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Siparişi iptal etme metodu
  void cancelOrder() {
    _orderRepository.cancelOrder(order); // OrderRepository'deki metodu çağır
    Get.back(); // Detay ekranından geri dön

    // İptal mesajı göster
    Get.snackbar(
      'İptal Edildi',
      '${order.customer.value} siparişi iptal edildi ve iptaller listesine taşındı.', // Reaktif değere .value ile erişim
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
