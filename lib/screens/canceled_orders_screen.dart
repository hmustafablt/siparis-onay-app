import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/canceled_orders_controller.dart'; // Controller'ı import et

class CanceledOrdersScreen extends StatelessWidget {
  const CanceledOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CanceledOrdersController'ı bul veya oluştur
    final CanceledOrdersController controller = Get.put(
      CanceledOrdersController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("İptal Edilen Siparişler"),
        centerTitle: true,
        backgroundColor: Colors.red.shade600,
      ),
      body: Obx(() {
        // Controller'daki listeyi dinliyoruz
        final canceledOrders = controller.canceledOrders;

        if (canceledOrders.isEmpty) {
          return const Center(
            child: Text(
              "İptal edilmiş sipariş bulunmamaktadır.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: canceledOrders.length,
            itemBuilder: (context, index) {
              final order = canceledOrders[index];
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
