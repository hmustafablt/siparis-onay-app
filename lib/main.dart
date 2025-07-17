import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import 'package:mbtest/binding/login_binding.dart';
import 'package:mbtest/binding/order_detail_binding.dart';
import 'package:mbtest/binding/order_list_binding.dart';
import 'package:mbtest/binding/profile_binding.dart';
import 'package:mbtest/binding/register_binding.dart';
import 'firebase_options.dart';

// Ekran importları
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'screens/register_screen.dart';
import 'screens/order_detail_screen.dart'; // OrderDetailScreen import edildi
import 'screens/order_list_screen.dart'; // OrderListScreen import edildi
import 'screens/profile_edit_screen.dart'; // ProfileEditScreen import edildi

// Servis importu
import 'services/order_repository.dart'; // OrderRepository import edildi

void main() async {
  // Flutter widget binding'lerinin başlatıldığından emin ol
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase'i başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // OrderRepository'yi GetX'e ekle (singleton olarak).
  // Bu, uygulama başladığında OrderRepository'nin bir instance'ının oluşturulmasını ve
  // Get.find<OrderRepository>() ile her yerden erişilebilir olmasını sağlar.
  Get.put(OrderRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // MaterialApp yerine GetMaterialApp kullanıldı
      title: 'Sipariş Takip',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,

      // GetX'in rota yönetimi için initialRoute ve getPages kullanılıyor
      initialRoute: Routes.LOGIN, // Uygulamanın başlangıç rotası
      getPages: AppPages.routes, // Tüm uygulama rotaları burada tanımlanacak
    );
  }
}

// GetX rota isimlerini tanımlayan yardımcı sınıf
abstract class Routes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const PROFILE_EDIT = '/profile_edit'; // Profil düzenleme rotası
  static const ORDER_DETAIL = '/order_detail'; // Sipariş detay rotası
  static const ORDER_LIST = '/order_list'; // Sipariş listesi rotası
}

// GetX sayfa tanımlarını içeren yardımcı sınıf
abstract class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(), // LoginScreen için LoginBinding eklendi
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      // HomePage'in altındaki tab'lar için Controller'lar kendi içinde Get.put ile başlatılabilir.
      // Eğer HomePage için özel bir binding gerekiyorsa buraya eklenebilir.
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(), // RegisterScreen için RegisterBinding eklendi
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileEditScreen(),
      binding: ProfileBinding(), // ProfileScreen için ProfileBinding eklendi
    ),
    GetPage(
      name: Routes.ORDER_DETAIL,
      page: () => const OrderDetailScreen(),
      binding:
          OrderDetailBinding(), // OrderDetailScreen için OrderDetailBinding eklendi
    ),
    GetPage(
      name: Routes.ORDER_LIST,
      page: () => const OrderListScreen(),
      binding:
          OrderListBinding(), // OrderListScreen için OrderListBinding eklendi
    ),
    GetPage(
      name: Routes.PROFILE_EDIT,
      page: () => const ProfileEditScreen(), // ProfileEditScreen eklendi
      // binding: ProfileEditBinding(), // ProfileEditScreen için binding daha sonra eklenecek
    ),
    // Ana sayfa '/' rotası için özel bir durum. Genellikle initialRoute'u doğrudan bir named route'a bağlamak daha temizdir.
    // Eğer '/' rotası hala gerekli ise:
    GetPage(
      name: '/', // '/' rotası da LoginScreen'e yönlendirilsin
      page: () => const LoginScreen(),
      binding: LoginBinding(), // LoginScreen için LoginBinding eklendi
    ),
  ];
}
