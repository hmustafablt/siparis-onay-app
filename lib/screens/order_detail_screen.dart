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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sipariş Detayı'),
        previousPageTitle: 'Geri',
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReadonlyCupertinoField('Müşteri', order.customer),
                const SizedBox(height: 16),
                _buildReadonlyCupertinoField('Sipariş No', order.id),
                const SizedBox(height: 16),
                _buildReadonlyCupertinoField('Toplam Tutar', '${order.totalAmount} ₺'),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: CupertinoButton.filled(
                      onPressed: () => _approveOrder(context),
                      color: Colors.green,
                      child: const Text('Onayla'),
                    ),
                    ),
                    const SizedBox(width:16),
                    Expanded(child: CupertinoButton.filled(
                      child: const Text('İptal Et'),
                      onPressed: () => _approveOrder(context),),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadonlyCupertinoField(String placeholder, String value) {
    return CupertinoTextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      placeholder: placeholder,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator),
        ),
      ),
    );
  }
}
