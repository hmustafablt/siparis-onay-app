import 'package:get/get.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    // OrderDetailController'ı tembelce (lazy) yükle.
    // Controller, Get.arguments ile Order objesini alacak.
    Get.lazyPut<OrderDetailController>(() => OrderDetailController());
  }
}
