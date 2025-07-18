import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // RegisterController'ı tembelce (lazy) yükle.
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
