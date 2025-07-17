import 'package:flutter/material.dart'; // TextEditingController için
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // Routes sınıfına erişmek için

class LoginController extends GetxController {
  // TextEditingController'lar GetxController içinde yönetilir
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reaktif durum değişkenleri
  final RxString _errorMessage = RxString(''); // Hata mesajı
  final RxBool _isLoading = RxBool(false); // Yüklenme durumu

  // Getter'lar ile reaktif değerlere erişim
  String? get errorMessage =>
      _errorMessage.value.isEmpty ? null : _errorMessage.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Controller başlatıldığında yapılacak işlemler
    // Örneğin, kaydedilmiş e-posta veya şifre varsa buraya yüklenebilir.
    print('LoginController başlatıldı');
  }

  @override
  void onClose() {
    // Controller kapatıldığında (bellekten atıldığında) TextEditingController'ları dispose et
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
    print('LoginController kapatıldı');
  }

  // Giriş yapma metodu
  Future<void> login() async {
    _errorMessage.value = ''; // Hata mesajını temizle
    _isLoading.value = true; // Yüklenme durumunu başlat

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Başarılıysa anasayfaya yönlendir (tüm önceki rotaları kapat)
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      _errorMessage.value =
          e.message ?? 'Bir hata oluştu.'; // Hata mesajını ayarla
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
    } catch (e) {
      _errorMessage.value =
          'Beklenmedik bir hata oluştu: ${e.toString()}'; // Diğer hatalar
      print('Genel Hata: ${e.toString()}');
    } finally {
      _isLoading.value = false; // Yüklenme durumunu bitir
    }
  }

  // Kayıt olma ekranına yönlendirme
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}
