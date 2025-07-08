import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_repository.dart';

class ApprovedOrdersScreen extends StatefulWidget {
  const ApprovedOrdersScreen({super.key});

  @override
  State<ApprovedOrdersScreen> createState() => _ApprovedOrdersScreenState();
}

class _ApprovedOrdersScreenState extends State<ApprovedOrdersScreen> {
  void _revertApproval(Order order) {
    OrderRepository.revertOrderToPending(order);
    setState(() {}); // Listeyi yenile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${order.customer} siparişi tekrar bekleyenlere alındı."),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderRepository.approvedOrders;

    Widget _buildOrderCard(Order order) {
      return Dismissible(
        key: Key(order.id),
        direction: DismissDirection.endToStart, // Sola kaydırarak silme
        onDismissed: (direction) {
          _revertApproval(order);
        },
        background: Container(
          color: Colors.orange,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.undo, color: Colors.white, size: 32),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.indigo.withOpacity(0.3),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                order.customer.isNotEmpty
                    ? order.customer[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.green,
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
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Onaylı Siparişler"),
        backgroundColor: Colors.indigo,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "Henüz onaylı sipariş yok.",
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
