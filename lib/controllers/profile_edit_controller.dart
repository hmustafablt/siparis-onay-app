import 'package:flutter/material.dart'; // TextEditingController, SnackBar için
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form alanları için TextEditingController'lar
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Reaktif durum değişkenleri
  final RxBool isLoading = false.obs; // Yüklenme durumu
  final RxString errorMessage = ''.obs;

  // Düzenlenecek orijinal kullanıcı verileri (ProfileScreen'dan gelecek)
  Map<String, dynamic>? initialUserData;

  @override
  void onInit() {
    super.onInit();
    // ProfileScreen'dan gönderilen kullanıcı verilerini al
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      initialUserData = Get.arguments as Map<String, dynamic>;
      // Controller'ları başlangıç verileriyle doldur
      firstNameController.text = initialUserData!['firstName'] ?? '';
      lastNameController.text = initialUserData!['lastName'] ?? '';
      titleController.text = initialUserData!['title'] ?? '';
      locationController.text = initialUserData!['location'] ?? '';
      print('ProfileEditController: Initial user data loaded.');
    } else {
      print('ProfileEditController: No initial user data received.');
      // Eğer veri gelmezse, kullanıcıyı geri yönlendirebiliriz veya boş bir form gösterebiliriz.
      // Şimdilik sadece uyarı verelim.
    }
  }

  @override
  void onClose() {
    // Controller kapatıldığında TextEditingController'ları dispose et
    firstNameController.dispose();
    lastNameController.dispose();
    titleController.dispose();
    locationController.dispose();
    super.onClose();
    print('ProfileEditController kapatıldı');
  }

  // Kullanıcı bilgilerini güncelleme metodu
  Future<void> updateProfile() async {
    errorMessage.value = ''; // Hata mesajını temizle
    isLoading.value = true; // Yüklenme durumunu başlat

    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      errorMessage.value = 'Kullanıcı oturumu bulunamadı.';
      isLoading.value = false;
      Get.snackbar(
        'Hata',
        'Kullanıcı oturumu bulunamadı. Lütfen tekrar giriş yapın.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _firestore.collection('users').doc(uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'title': titleController.text.trim(),
        'location': locationController.text.trim(),
        // E-posta ve şifre burada güncellenmez, ayrı bir işlem gerektirir.
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Başarılı mesajı göster
      Get.snackbar(
        'Başarılı',
        'Profiliniz başarıyla güncellendi.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Kısa bir gecikme ekle ve önceki sayfaya dön
      await Future.delayed(const Duration(seconds: 2));
      Get.back(); // Profil ekranına geri dön
    } on FirebaseException catch (e) {
      errorMessage.value = e.message ?? 'Firebase hatası oluştu.';
      print('Firebase Hatası: ${e.code} - ${e.message}');
      Get.snackbar(
        'Hata',
        'Profil güncellenirken bir hata oluştu: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Beklenmeyen bir hata oluştu: ${e.toString()}';
      print('Genel Hata: ${e.toString()}');
      Get.snackbar(
        'Hata',
        'Profil güncellenirken beklenmeyen bir hata oluştu.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false; // Yüklenme durumunu bitir
    }
  }
}
