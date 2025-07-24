import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX kütüphanesi import edildi
import '../controllers/login_controller.dart'; // LoginController'ı import et

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/kipas_logo.png', height: 100),

              const SizedBox(height: 24),
              const Text(
                'Kipaş Holding Giriş',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff002B5C),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: controller
                    .emailController, // Controller'dan TextEditingController'ı al
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller
                    .passwordController, // Controller'dan TextEditingController'ı al
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => controller.errorMessage != null
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
                    onPressed: controller.isLoading ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff002B5C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Giriş Yap',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.goToRegister,
                child: const Text(
                  'Hesabınız yok mu? Kayıt Ol',
                  style: TextStyle(fontSize: 14, color: Color(0xff002B5C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
