import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shadowColor: Colors.indigo.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.indigo,
          ),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : '-',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('Kullanıcı bilgileri bulunamadı')),
      );
    }

    final firstName = userData!['firstName'] ?? '';
    final lastName = userData!['lastName'] ?? '';
    final title = userData!['title'] ?? '';
    final location = userData!['location'] ?? '';
    final email = userData!['email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Çıkış Yap'),
                  content: const Text(
                    'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Vazgeç'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Çıkış Yap'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _auth.signOut();

                // Snackbar ile bilgi ver
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Başarıyla çıkış yapıldı.'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // 2 saniye bekle ve login ekranına yönlendir
                await Future.delayed(const Duration(seconds: 2));
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/profile_edit',
                arguments: userData,
              ).then((_) => _loadUserData());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            _infoCard('Ad', firstName, Icons.person),
            _infoCard('Soyad', lastName, Icons.person_outline),
            _infoCard('Ünvan', title, Icons.work_outline),
            _infoCard('Lokasyon', location, Icons.location_on_outlined),
            _infoCard('E-posta', email, Icons.email_outlined),
          ],
        ),
      ),
    );
  }
}
