import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_repository.dart';

class ApprovedOrdersScreen extends StatefulWidget {
  @override
  State<ApprovedOrdersScreen> createState() => _ApprovedOrdersScreenState();
}

class _ApprovedOrdersScreenState extends State<ApprovedOrdersScreen> {
  void _revertApproval(Order order) {
    OrderRepository.revertOrderToPending(order);
    setState(() {}); // Listeyi yenile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${order.customer} siparişi tekrar bekleyenlere alındı.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderRepository.approvedOrders;

    return Scaffold(
      appBar: AppBar(title: Text("Onaylı Siparişler")),
      body: orders.isEmpty
          ? Center(child: Text("Henüz onaylı sipariş yok."))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Dismissible(
            key: Key(order.id),
            direction: DismissDirection.endToStart, // Sola kaydırmayı engellemek için
            onDismissed: (direction) {
              _revertApproval(order);
            },
            background: Container(
              color: Colors.orange,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.undo, color: Colors.white),
            ),
            child: ListTile(
              title: Text(order.customer),
              subtitle: Text("${order.totalAmount} ₺"),
            ),
          );
        },
      ),
    );
  }
}
