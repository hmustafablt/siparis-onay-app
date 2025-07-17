import 'package:get/get.dart';
import '../controllers/login_controller.dart'; // LoginController'ı import et

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // LoginController'ı tembelce (lazy) yükle.
    // Bu, Controller'ın yalnızca ihtiyaç duyulduğunda oluşturulmasını sağlar.
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
