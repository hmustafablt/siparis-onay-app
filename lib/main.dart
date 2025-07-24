import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import 'package:mbtest/binding/login_binding.dart';
import 'package:mbtest/binding/order_detail_binding.dart';
import 'package:mbtest/binding/order_list_binding.dart';
import 'package:mbtest/binding/profile_binding.dart';
import 'package:mbtest/binding/profile_edit_binding.dart';
import 'package:mbtest/binding/register_binding.dart';
import 'package:mbtest/screens/profil_screen.dart';
import 'package:mbtest/screens/profile_edit_screen.dart';

import 'firebase_options.dart';

// Ekran importları
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'screens/register_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/order_list_screen.dart';

// Servis importu
import 'services/order_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      title: 'Sipariş Takip',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,

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
      binding: LoginBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => const HomePage()),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.ORDER_DETAIL,
      page: () => const OrderDetailScreen(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: Routes.ORDER_LIST,
      page: () => const OrderListScreen(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_EDIT,
      page: () => const ProfileEditScreen(),
      binding: ProfileEditBinding(),
    ),

    GetPage(
      name: '/', // '/' rotası da LoginScreen'e yönlendirilsin
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
  ];
}
