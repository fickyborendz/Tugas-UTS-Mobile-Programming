import 'package:flutter/material.dart';
import 'login_page.dart'; 
import 'package:app_pertama/pages/login_page.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  bool notifEnabled = true;

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout berhasil!')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // 🔹 Profil Pengguna
          const ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            title: Text('Nama Pengguna'),
            subtitle: Text('email@example.com'),
          ),
          const Divider(),

          // 🔹 Tema Gelap / Terang
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Mode Gelap'),
            value: isDarkMode,
            onChanged: (val) {
              setState(() => isDarkMode = val);
            },
          ),

          // 🔹 Notifikasi
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            value: notifEnabled,
            onChanged: (val) {
              setState(() => notifEnabled = val);
            },
          ),

          const Divider(),

          // 🔹 Backup & Restore
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Backup Data'),
            subtitle: const Text('Simpan data ke cloud atau lokal'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Backup belum tersedia')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: const Text('Restore Data'),
            subtitle: const Text('Pulihkan data dari backup'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Restore belum tersedia')),
              );
            },
          ),

          const Divider(),

          // 🔹 Tentang Aplikasi
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('Versi 1.0.0\nDibuat oleh Taufikur Rohman Shofi'),
            onTap: () {},
          ),

          // 🔹 Tombol Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
