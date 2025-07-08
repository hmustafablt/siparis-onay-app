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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  (userData!['firstName'] != null &&
                          userData!['firstName'].isNotEmpty)
                      ? userData!['firstName'][0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 40, color: Colors.indigo),
                ),
              ),
              const SizedBox(height: 24),
              _infoCard('Ad', userData!['firstName'] ?? '-', Icons.person),
              _infoCard(
                'Soyad',
                userData!['lastName'] ?? '-',
                Icons.person_outline,
              ),
              _infoCard('Ünvan', userData!['title'] ?? '-', Icons.work_outline),
              _infoCard(
                'Lokasyon',
                userData!['location'] ?? '-',
                Icons.location_on_outlined,
              ),
              _infoCard(
                'E-posta',
                userData!['email'] ?? '-',
                Icons.email_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
