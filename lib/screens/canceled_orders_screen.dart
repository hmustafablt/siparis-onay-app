import 'package:flutter/material.dart';
import '../services/order_repository.dart';
import '../models/order.dart';

class CanceledOrdersScreen extends StatefulWidget {
  const CanceledOrdersScreen({super.key});

  @override
  State<CanceledOrdersScreen> createState() => _CanceledOrdersScreenState();
}

class _CanceledOrdersScreenState extends State<CanceledOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final canceledOrders = OrderRepository.canceledOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("İptal Edilen Siparişler"),
        centerTitle: true,
        backgroundColor: Colors.red.shade600,
      ),
      body: canceledOrders.isEmpty
          ? const Center(
              child: Text(
                "İptal edilmiş sipariş bulunmamaktadır.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: canceledOrders.length,
              itemBuilder: (context, index) {
                final order = canceledOrders[index];

                return Dismissible(
                  key: Key(order.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.undo,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      OrderRepository.revertOrderToPending(order);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${order.customer} tekrar bekleyen siparişlere alındı.",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customer,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sipariş No: ${order.id}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${order.totalAmount} ₺",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
