import 'package:flutter/material.dart';
import '../models/order.dart';
import '../screens/order_detail_screen.dart';
import '../services/order_repository.dart';

class OrderListScreen extends StatefulWidget {
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final orders = OrderRepository.pendingOrders;

    return Scaffold(
      appBar: AppBar(title: Text("Bekleyen Siparişler")),
      body: orders.isEmpty
          ? Center(child: Text("Tüm siparişler onaylandı"))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text(order.customer),
            subtitle: Text("${order.totalAmount} ₺"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(order: order),
                ),
              );
              setState(() {}); // Onaylandıysa listeyi güncelle
            },
          );
        },
      ),
    );
  }
}
