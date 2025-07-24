import 'package:get/get.dart';
import '../controllers/login_controller.dart'; // LoginController'ı import et

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
