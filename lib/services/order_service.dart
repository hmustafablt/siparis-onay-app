import '../models/order.dart';

class OrderService {
  static Future<List<Order>> fetchAllOrders() async {
    await Future.delayed(Duration(milliseconds: 800)); // Simülasyon için
    return [
      Order(id: 'S001', customer: 'Ahmet Tekstil', totalAmount: 12500, status: 'pending'),
      Order(id: 'S002', customer: 'Bora Giyim', totalAmount: 8200, status: 'approved'),
      Order(id: 'S003', customer: 'Mavi Moda', totalAmount: 9700, status: 'pending'),
    ];
  }

  static Future<List<Order>> fetchPendingOrders() async {
    final all = await fetchAllOrders();
    return all.where((order) => order.status == 'pending').toList();
    }
  static Future<List<Order>> fetchApprovedOrders() async {
    final all = await fetchAllOrders();
    return all.where((order) => order.status == 'approved').toList();

  }
}
