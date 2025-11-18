import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT HALAMAN
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/item_page.dart';
import 'pages/setting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventori App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      // ➜ mulai dari halaman login
      home: const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // ➜ Halaman yang muncul di bottom navigation
  final List<Widget> _pages = const [
    HomePage(),     // Nota
    ItemPage(),     // Item
    SettingPage(),  // Pengaturan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Nota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
