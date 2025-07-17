import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/register_controller.dart'; // RegisterController'ı import et

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RegisterController'ı bul veya oluştur.
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        backgroundColor: Colors.indigo, // AppBar rengi eklendi
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller
                    .firstNameController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller
                    .lastNameController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller
                    .titleController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'Ünvan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller
                    .locationController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'Lokasyon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller
                    .emailController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller
                    .passwordController, // Controller'dan TextEditingController'ı al
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () =>
                    controller.errorMessage !=
                        null // Reaktif hata mesajını dinle
                    ? Text(
                        controller.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink(), // Hata yoksa boşluk bırak
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : controller
                              .register, // Reaktif yüklenme durumunu dinle
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo, // Buton rengi eklendi
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        controller
                            .isLoading // Reaktif yüklenme durumunu dinle
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          ) // Yüklenme göstergesi rengi
                        : const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ), // Metin rengi
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
