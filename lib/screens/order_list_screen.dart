import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/order_list_controller.dart'; // OrderListController'ı import et

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // OrderListController'ı bul veya oluştur
    final OrderListController controller = Get.put(OrderListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bekleyen Siparişler"),
        // AppBar rengi için Color.fromARGB(0, 30, 29, 131) şeffaf bir renk verir.
        // Genellikle tam opak bir renk tercih edilir.
        // Örnek: Colors.indigo veya Color(0xFF1E1D83)
        backgroundColor: Colors.indigo,
      ),
      body: Obx(() {
        // Controller'daki reaktif listeyi dinliyoruz
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
              ); // Controller'daki metodu çağır
            },
          );
        }
      }),
    );
  }
}
