import 'package:get/get.dart';
import '../controllers/order_list_controller.dart';

class OrderListBinding extends Bindings {
  @override
  void dependencies() {
    // OrderListController'ı tembelce (lazy) yükle.
    Get.lazyPut<OrderListController>(() => OrderListController());
  }
}
