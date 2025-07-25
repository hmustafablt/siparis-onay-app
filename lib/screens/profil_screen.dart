import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.goToProfileEdit,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // userData null ise veya boşsa, uygun bir mesaj gösteriyor.
        if (controller.userData.value == null ||
            controller.userData.value!.isEmpty) {
          return const Center(
            child: Text('Kullanıcı bilgileri bulunamadı veya boş.'),
          );
        }

        // userData'nın null olmadığını garanti altına alıyoruz
        final userData = controller.userData.value!;

        // Controller'dan getter'lar aracılığıyla verilere erişim
        // Null kontrolü yaparak varsayılan değerler atıyoruz
        final String firstName = userData['firstName'] ?? '';
        final String lastName = userData['lastName'] ?? '';
        final String title = userData['title'] ?? '';
        final String location = userData['location'] ?? '';
        final String email = userData['email'] ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  (firstName.isNotEmpty) ? firstName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$firstName $lastName',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title.isNotEmpty ? title : '-',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              controller.buildInfoCard('Ad', firstName, Icons.person),
              controller.buildInfoCard('Soyad', lastName, Icons.person_outline),
              controller.buildInfoCard('Ünvan', title, Icons.work_outline),
              controller.buildInfoCard(
                'Lokasyon',
                location,
                Icons.location_on_outlined,
              ),
              controller.buildInfoCard('E-posta', email, Icons.email_outlined),
            ],
          ),
        );
      }),
    );
  }
}
