import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order.dart';
import '../services/order_repository.dart';

class ApprovedOrdersController extends GetxController {
  // OrderRepository'nin instance'ını GetX'ten alıyoruz.
  // Bu, main.dart'ta Get.put(OrderRepository()) yapıldığı varsayımına dayanır.
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // Onaylı siparişler listesini OrderRepository'den doğrudan referans alıyoruz.
  // Bu liste zaten RxList olduğu için tekrar .obs yapmamıza gerek yok.
  late final RxList<Order> approvedOrders;

  @override
  void onInit() {
    super.onInit();
    // approvedOrders listesini OrderRepository'den doğrudan referans al
    approvedOrders = _orderRepository.approvedOrders;
    print(
      'ApprovedOrdersController başlatıldı. Onaylı sipariş sayısı: ${approvedOrders.length}',
    );
  }

  // Onaylı siparişi bekleyen siparişlere geri alma işlemi
  void revertApproval(Order order) {
    _orderRepository.revertOrderToPending(order);

    Get.snackbar(
      "Sipariş Durumu",
      "${order.customer.value} siparişi tekrar bekleyenlere alındı.", // .value ile reaktif değere erişim
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    // UI otomatik olarak güncellenecek çünkü approvedOrders listesi reaktif.
  }

  // Sipariş kartını oluşturma metodu
  Widget buildOrderCard(Order order) {
    return Dismissible(
      key: Key(order.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        revertApproval(order); // Controller metodunu çağır
      },
      background: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.undo, color: Colors.white, size: 32),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.indigo.withOpacity(0.3),
        child: Obx(
          () => // Reaktif değerler için Obx kullanıyoruz
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                order
                        .customer
                        .value
                        .isNotEmpty // .value ile reaktif değere erişim
                    ? order.customer.value[0]
                          .toUpperCase() // .value ile reaktif değere erişim
                    : '?',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            title: Text(
              order.customer.value, // .value ile reaktif değere erişim
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              "${order.totalAmount.value} ₺",
            ), // .value ile reaktif değere erişim
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
