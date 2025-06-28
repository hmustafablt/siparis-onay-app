import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  OrderDetailScreen({required this.order});

  void _approveOrder(BuildContext context) {
    // Buraya API çağrısı yazılabilir
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sipariş onaylandı')));
    Navigator.pop(context);
  }

  void _rejectOrder(BuildContext context) {
    // Buraya API çağrısı yazılabilir
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sipariş reddedildi')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sipariş Detayı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Sipariş No: ${order.id}', style: TextStyle(fontSize: 18)),
            Text('Müşteri: ${order.customer}'),
            Text('Tutar: ${order.totalAmount} TL'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _approveOrder(context),
              child: Text('Onayla'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton(
              onPressed: () => _rejectOrder(context),
              child: Text('Reddet'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
