import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/profile_controller.dart'; // ProfileController'ı import et

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ProfileController'ı bul veya oluştur.
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout, // Controller metodunu çağır
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.goToProfileEdit, // Controller metodunu çağır
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userData.value == null) {
          return const Center(child: Text('Kullanıcı bilgileri bulunamadı'));
        }

        final userData =
            controller.userData.value!; // Nullable olduğu için ! ile erişim

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(
                    (userData['firstName'] != null &&
                            userData['firstName'].isNotEmpty)
                        ? userData['firstName'][0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.indigo),
                  ),
                ),
                const SizedBox(height: 24),
                controller.buildInfoCard(
                  'Ad',
                  userData['firstName'] ?? '-',
                  Icons.person,
                ),
                controller.buildInfoCard(
                  'Soyad',
                  userData['lastName'] ?? '-',
                  Icons.person_outline,
                ),
                controller.buildInfoCard(
                  'Ünvan',
                  userData['title'] ?? '-',
                  Icons.work_outline,
                ),
                controller.buildInfoCard(
                  'Lokasyon',
                  userData['location'] ?? '-',
                  Icons.location_on_outlined,
                ),
                controller.buildInfoCard(
                  'E-posta',
                  userData['email'] ?? '-',
                  Icons.email_outlined,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
