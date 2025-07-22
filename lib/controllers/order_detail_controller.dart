import 'package:get/get.dart';
import 'package:flutter/material.dart'; // SnackBar ve WidgetsBinding için gerekli
import '../models/order.dart';
import '../services/order_repository.dart';

class OrderDetailsController extends GetxController {
  // OrderRepository'nin instance'ını GetX'ten alıyoruz.
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // Bu ekranın göstereceği Order nesnesi reaktif olarak tutulacak
  final Rx<Order?> order = Rx<Order?>(null); // Nullable ve reaktif yapıldı

  @override
  void onInit() {
    super.onInit();
    // Sayfaya geçerken gönderilen sipariş ID'sini al.
    final String? orderId = Get.arguments;
    print(
      'OrderDetailController onInit: Received orderId: $orderId',
    ); // Debug print

    if (orderId != null) {
      // OrderRepository'den siparişi ID'ye göre çek
      final foundOrder = _orderRepository.findOrderById(orderId);
      if (foundOrder != null) {
        order.value = foundOrder; // Reaktif sipariş nesnesini ata
        print(
          'OrderDetailController: Order found. ID: ${order.value!.id}, Customer: ${order.value!.customer.value}',
        ); // Debug print
      } else {
        // Sipariş bulunamazsa, navigasyonu ve snackbar'ı bir sonraki frame'e ertele
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Düzeltme burada!
          print(
            'OrderDetailController: Order with ID "$orderId" not found in repository. Navigating back.',
          ); // Debug print
          Get.back();
          Get.snackbar(
            'Hata',
            'Sipariş bulunamadı.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
    } else {
      // Geçersiz veya eksik sipariş ID'si durumunda, navigasyonu ve snackbar'ı bir sonraki frame'e ertele
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Düzeltme burada!
        print(
          'OrderDetailController: No order ID received in arguments. Navigating back.',
        ); // Debug print
        Get.back();
        Get.snackbar(
          'Hata',
          'Sipariş detayı yüklenemedi. Geçersiz ID.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  // Siparişi onaylama metodu
  void approveOrder() {
    if (order.value != null) {
      _orderRepository.approveOrder(
        order.value!,
      ); // OrderRepository'deki metodu çağır
      Get.back(); // Detay ekranından geri dön

      // Başarı mesajı göster
      Get.snackbar(
        'Başarılı',
        '${order.value!.customer.value} siparişi onaylandı.', // Reaktif değere .value ile erişim
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      print(
        'approveOrder: order.value is null, cannot approve.',
      ); // Debug print
    }
  }

  // Siparişi iptal etme metodu
  void cancelOrder() {
    if (order.value != null) {
      _orderRepository.cancelOrder(
        order.value!,
      ); // OrderRepository'deki metodu çağır
      Get.back(); // Detay ekranından geri dön

      // İptal mesajı göster
      Get.snackbar(
        'İptal Edildi',
        '${order.value!.customer.value} siparişi iptal edildi ve iptaller listesine taşındı.', // Reaktif değere .value ile erişim
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      print('cancelOrder: order.value is null, cannot cancel.'); // Debug print
    }
  }
}
