import 'package:get/get.dart';
import 'package:flutter/material.dart'; // SnackBar için gerekli
import '../models/order.dart';
import '../services/order_repository.dart'; // OrderRepository'yi import et

class CanceledOrdersController extends GetxController {
  // OrderRepository'nin instance'ını GetX'ten alıyoruz.
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // İptal edilmiş siparişler listesini OrderRepository'den doğrudan referans alıyoruz.
  // Bu liste zaten RxList olduğu için tekrar .obs yapmamıza gerek yok.
  late final RxList<Order> canceledOrders;

  @override
  void onInit() {
    super.onInit();
    // canceledOrders listesini OrderRepository'den doğrudan referans al
    canceledOrders = _orderRepository.canceledOrders;
    print(
      'CanceledOrdersController başlatıldı. İptal edilen sipariş sayısı: ${canceledOrders.length}',
    );
  }

  // Siparişi bekleyen duruma geri alma işlemi
  void revertOrderToPending(Order order) {
    _orderRepository.revertOrderToPending(
      order,
    ); // OrderRepository metodunu çağır

    // SnackBar göstermek için Get.snackbar kullanıyoruz
    Get.snackbar(
      "Sipariş Durumu",
      "${order.customer.value} tekrar bekleyen siparişlere alındı.", // .value ile reaktif değere erişim
      backgroundColor: Colors.blue.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    // UI otomatik olarak güncellenecek çünkü canceledOrders listesi reaktif.
  }

  // Sipariş kartını oluşturma metodu
  Widget buildOrderCard(Order order) {
    return Dismissible(
      // Sola kaydırma ile siparişi tekrar bekleyen siparişlere alma özelliği.
      key: Key(order.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.undo, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        revertOrderToPending(order); // Controller metodunu çağır
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => // Reaktif değerler için Obx kullanıyoruz
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customer.value, // .value ile reaktif değere erişim
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sipariş No: ${order.id}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${order.totalAmount.value} ₺", // .value ile reaktif değere erişim
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
