import 'package:flutter/material.dart'; // TextEditingController, SnackBar için
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  // TextEditingController'lar GetxController içinde yönetilir
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
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
    print('RegisterController başlatıldı');
  }

  @override
  void onClose() {
    // Controller kapatıldığında (bellekten atıldığında) TextEditingController'ları dispose et
    firstNameController.dispose();
    lastNameController.dispose();
    titleController.dispose();
    locationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
    print('RegisterController kapatıldı');
  }

  // Kayıt olma metodu
  Future<void> register() async {
    _errorMessage.value = ''; // Hata mesajını temizle
    _isLoading.value = true; // Yüklenme durumunu başlat

    try {
      // Firebase Authentication'a kayıt
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user!.uid;

      // Firestore'a kullanıcı bilgilerini ekleme
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'title': titleController.text.trim(),
        'location': locationController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Başarılıysa kullanıcıya bilgi ver
      Get.snackbar(
        'Başarılı',
        'Hesabınız başarıyla oluşturuldu. Giriş yapabilirsiniz.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2), // SnackBar'ın süresi
      );

      // SnackBar'ın görünmesi için kısa bir gecikme ekle
      await Future.delayed(const Duration(seconds: 2)); // Gecikme eklendi

      // Giriş ekranına geri dön
      Get.back();
    } on FirebaseAuthException catch (e) {
      _errorMessage.value =
          e.message ?? 'Bir hata oluştu.'; // Hata mesajını ayarla
      print('Firebase Auth Hatası: ${e.code} - ${e.message}');
    } catch (e) {
      _errorMessage.value =
          "Beklenmeyen bir hata oluştu: ${e.toString()}"; // Diğer hatalar
      print('Genel Hata: ${e.toString()}');
    } finally {
      _isLoading.value = false; // Yüklenme durumunu bitir
    }
  }
}
