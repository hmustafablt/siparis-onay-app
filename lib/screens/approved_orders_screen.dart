import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import 'package:mbtest/controllers/approved_orders_controller.dart';

class ApprovedOrdersScreen extends StatelessWidget {
  const ApprovedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ApprovedOrdersController'ı bul veya oluştur
    final ApprovedOrdersController controller = Get.put(
      ApprovedOrdersController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Onaylı Siparişler"),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        // Controller'daki listeyi dinliyoruz
        final orders = controller.approvedOrders;

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              "Henüz onaylı sipariş yok.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: orders.length,
            itemBuilder: (context, index) =>
                controller.buildOrderCard(orders[index]),
          );
        }
      }),
    );
  }
}
