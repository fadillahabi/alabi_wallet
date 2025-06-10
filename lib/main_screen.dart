import 'package:daily_financial_recording/dashboard.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String id = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _screen = [DashboardUang()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
          print("Halaman Saat ini : $_selectedIndex");
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black.withOpacity(0.1),
        unselectedItemColor: Colors.grey[400],
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: "Exit"),
        ],
      ),
    );
  }
}
