import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_repository.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  void _approveOrder(BuildContext context) {
    OrderRepository.approveOrder(order);
    Navigator.pop(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Başarılı'),
        content: const Text('Sipariş onaylandı.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _cancelOrder(BuildContext context) {
    OrderRepository.cancelOrder(order); // 👈 İptal işlemi yapılır
    Navigator.pop(context); // Detay ekranından çıkılır

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('İptal Edildi'),
        content: const Text(
          'Sipariş iptal edildi ve iptaller listesine taşındı.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () => Navigator.of(context).pop(), // Alert kapatılır
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sipariş Detayı'),
        previousPageTitle: 'Geri',
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('Müşteri'),
                  _buildValue(order.customer),
                  const SizedBox(height: 16),

                  _buildTitle('Sipariş No'),
                  _buildValue(order.id),
                  const SizedBox(height: 16),

                  _buildTitle('Toplam Tutar'),
                  _buildValue('${order.totalAmount} ₺'),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () => _approveOrder(context),
                          color: CupertinoColors.activeGreen,
                          child: const Text('Onayla'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: () => _cancelOrder(context),
                          color: CupertinoColors.systemRed,
                          child: const Text('İptal Et'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.systemGrey,
      ),
    );
  }

  Widget _buildValue(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value, style: const TextStyle(fontSize: 18)),
    );
  }
}
