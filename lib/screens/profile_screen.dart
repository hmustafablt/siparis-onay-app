import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              // Çıkış yapıldıktan sonra giriş sayfasına yönlendir
              Navigator.pushReplacementNamed(context, '/');
              // Eğer named route yoksa, alternatif:
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LoginScreen()),
              // );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Kullanıcı bilgileri ve çıkış ekranı"),
      ),
    );
  }
}
