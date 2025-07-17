import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Widget'lar ve ikonlar için
import '../models/order.dart';
import '../services/order_repository.dart';
import '../main.dart'; // Routes sınıfına erişmek için

class OrderListController extends GetxController {
  // OrderRepository'nin instance'ını GetX'ten alıyoruz.
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  // Bekleyen siparişler listesini OrderRepository'den doğrudan referans alıyoruz.
  // Bu liste zaten RxList olduğu için tekrar .obs yapmamıza gerek yok.
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
    Get.toNamed(
      Routes.ORDER_DETAIL,
      arguments: order.id,
    ); // Düzeltme burada yapıldı!
  }

  // Sipariş kartını oluşturma metodu
  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.indigo.withOpacity(0.3),
      child: Obx(
        () => // Reaktif değerler için Obx kullanıyoruz
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              order
                      .customer
                      .value
                      .isNotEmpty // .value ile reaktif değere erişim
                  ? order.customer.value[0]
                        .toUpperCase() // .value ile reaktif değere erişim
                  : '?',
              style: const TextStyle(
                color: Colors.indigo,
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
          trailing: const Icon(
            Icons.arrow_forward_ios, // Material ikon kullanıldı
            color: Colors.indigo,
          ),
          onTap: () {
            goToOrderDetail(order); // Controller metodunu çağır
          },
        ),
      ),
    );
  }
}
