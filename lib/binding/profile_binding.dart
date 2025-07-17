import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // ProfileController'ı tembelce (lazy) yükle.
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
