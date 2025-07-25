import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_list_controller.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderListController controller = Get.put(OrderListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bekleyen Siparişler"),
        backgroundColor: Colors.indigo,
      ),
      body: Obx(() {
        // Controller'daki listeyi dinliyoruz
        final orders = controller.pendingOrders;

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              "Tüm siparişler onaylandı",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return controller.buildOrderCard(
                order,
              ); // Controller'daki metodu çağırıyoruz
            },
          );
        }
      }),
    );
  }
}
