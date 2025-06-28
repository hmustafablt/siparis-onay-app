import '../models/order.dart';

class OrderService {
  static Future<List<Order>> fetchOrders() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Order(id: 'S001', customer: 'Ahmet Tekstil', totalAmount: 12500, status: 'pending'),
      Order(id: 'S002', customer: 'Bora Giyim', totalAmount: 8200, status: 'pending'),
    ];
  }
}
