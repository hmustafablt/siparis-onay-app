import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/order_detail_screen.dart';
import '../services/order_repository.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final orders = OrderRepository.pendingOrders;

    Widget _buildOrderCard(order) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.indigo.withOpacity(0.3),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              order.customer.isNotEmpty ? order.customer[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          title: Text(
            order.customer,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text("${order.totalAmount} ₺"),
          trailing: const Icon(
            CupertinoIcons.arrow_right_circle,
            color: Colors.indigo,
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(order: order),
              ),
            );
            setState(() {}); // Onaylandıysa listeyi güncelle
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bekleyen Siparişler"),
        backgroundColor: Color.fromARGB(0, 30, 29, 131),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "Tüm siparişler onaylandı",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orders.length,
              itemBuilder: (context, index) => _buildOrderCard(orders[index]),
            ),
    );
  }
}
