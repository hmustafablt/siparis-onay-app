import 'package:get/get.dart';
import 'package:flutter/material.dart'; // IconData ve SnackBar için
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart'; // Routes sınıfına erişmek için

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı verilerini reaktif olarak tutuyoruz
  final Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);
  // Yüklenme durumunu reaktif olarak tutuyoruz
  final RxBool isLoading = true.obs;

  String? get firstName => null;

  String? get lastName => null;

  String? get title => null;

  String? get location => null;

  String? get email => null;

  @override
  void onInit() {
    super.onInit();
    // Controller başlatıldığında kullanıcı verilerini yükle
    _loadUserData();
    // Firebase Auth durumu değiştiğinde (örneğin çıkış yapıldığında) dinle
    // Bu, kullanıcının oturum açma durumuna göre UI'ı güncellemek için faydalıdır.
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // Kullanıcı çıkış yaptıysa veya oturumu kapandıysa
        userData.value = null;
        isLoading.value = false;
        Get.offAllNamed(Routes.LOGIN); // Giriş ekranına yönlendir
      } else {
        _loadUserData(); // Kullanıcı oturum açtıysa verileri yeniden yükle
      }
    });
  }

  // Kullanıcı verilerini Firestore'dan yükleme metodu
  Future<void> _loadUserData() async {
    isLoading.value = true;
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      userData.value = null;
      isLoading.value = false;
      print('ProfileController: No user ID found.');
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userData.value = doc.data();
        print('ProfileController: User data loaded for UID: $uid');
      } else {
        userData.value = null;
        print('ProfileController: User data not found for UID: $uid');
      }
    } catch (e) {
      print('ProfileController: Error loading user data: $e');
      Get.snackbar(
        'Hata',
        'Kullanıcı bilgileri yüklenirken bir hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      userData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Çıkış yapma metodu
  Future<void> logout() async {
    try {
      await _auth.signOut();
      // authStateChanges listener'ı zaten Routes.LOGIN'e yönlendirecek.
      Get.snackbar(
        'Başarılı',
        'Başarıyla çıkış yapıldı.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('ProfileController: Error during logout: $e');
      Get.snackbar(
        'Hata',
        'Çıkış yapılırken bir hata oluştu: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Profil düzenleme ekranına gitme metodu
  void goToProfileEdit() {
    // Mevcut kullanıcı verilerini argüman olarak gönder
    Get.toNamed(Routes.PROFILE_EDIT, arguments: userData.value)?.then((_) {
      // Düzenleme ekranından dönüldüğünde verileri yenile
      _loadUserData();
    });
  }

  // Bilgi kartı widget'ı (Controller içinde de tanımlanabilir veya View'da kalabilir)
  // Bu durumda, controller'dan alınan veriyi kullanacağı için burada tanımlamak mantıklı.
  Widget buildInfoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
    );
  }
}
