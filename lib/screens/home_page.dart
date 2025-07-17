import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi

// Controller import edildi
import '../controllers/home_controller.dart';

// Ekran importları (Controller'da da tanımlanabilir ama View'da da kalabilir)

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeController'ı bul veya oluştur (ilk kez çağrıldığında oluşturulur)
    // Eğer bu sayfaya bir binding üzerinden geliniyorsa Get.find<HomeController>() da kullanılabilir.
    // Ancak Get.put genellikle daha yaygın bir başlangıç noktasıdır.
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      // Obx, controller.currentIndex.value değiştiğinde body'yi yeniden inşa eder
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex:
              controller.currentIndex.value, // Controller'dan değeri al
          onTap: controller.changePage, // Controller'daki metodu çağır
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Siparişler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Onaylılar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cancel),
              label: 'İptal Edilenler',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
