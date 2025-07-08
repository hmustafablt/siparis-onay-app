import '../models/order.dart';

class OrderRepository {
  static List<Order> _orders = [
    Order(
      id: 'S001',
      customer: 'Ahmet Tekstil',
      totalAmount: 12500,
      status: 'pending',
    ),
    Order(
      id: 'S002',
      customer: 'Bora Giyim',
      totalAmount: 8200,
      status: 'pending',
    ),
    Order(
      id: 'S003',
      customer: 'Mavi Moda',
      totalAmount: 9700,
      status: 'approved',
    ),
  ];

  static final List<Order> canceledOrders = [];

  static List<Order> get pendingOrders =>
      _orders.where((o) => o.status == 'pending').toList();

  static List<Order> get approvedOrders =>
      _orders.where((o) => o.status == 'approved').toList();

  static void approveOrder(Order order) {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = Order(
        id: order.id,
        customer: order.customer,
        totalAmount: order.totalAmount,
        status: 'approved',
      );
    }
  }

  static void cancelOrder(Order order) {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders.removeAt(index);
    }
    canceledOrders.add(
      Order(
        id: order.id,
        customer: order.customer,
        totalAmount: order.totalAmount,
        status: 'canceled',
      ),
    );
  }

  static void revertOrderToPending(Order order) {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index == -1) {
      _orders.add(
        Order(
          id: order.id,
          customer: order.customer,
          totalAmount: order.totalAmount,
          status: 'pending',
        ),
      );
    } else {
      _orders[index] = Order(
        id: order.id,
        customer: order.customer,
        totalAmount: order.totalAmount,
        status: 'pending',
      );
    }

    canceledOrders.removeWhere((o) => o.id == order.id);
  }
}
