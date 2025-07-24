import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_repository.dart';
import '../main.dart'; // Routes sınıfına erişmek için

class OrderListController extends GetxController {
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  late final RxList<Order> pendingOrders;

  @override
  void onInit() {
    super.onInit();
    // pendingOrders listesini OrderRepository'den doğrudan referans al
    pendingOrders = _orderRepository.pendingOrders;
    print(
      'OrderListController başlatıldı. Bekleyen sipariş sayısı: ${pendingOrders.length}',
    );
  }

  // Sipariş detay ekranına gitme metodu
  void goToOrderDetail(Order order) {
    // GetX'in rota yönetimini kullanarak sipariş detay ekranına git
    // Sadece siparişin ID'sini arguments olarak gönderiyoruz.
    print(
      'OrderListController: Navigating to OrderDetail with ID: ${order.id}',
    );
    Get.toNamed(Routes.ORDER_DETAIL, arguments: order.id);
  }

  // Sipariş kartını oluşturma metodu
  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.indigo.withOpacity(0.3),
      child: Obx(
        () => ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              order
                      .customer
                      .value
                      .isNotEmpty // .value ile reaktif değere erişim
                  ? order.customer.value[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          title: Text(
            order.customer.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text("${order.totalAmount.value} ₺"),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo),
          onTap: () {
            goToOrderDetail(order);
          },
        ),
      ),
    );
  }
}
