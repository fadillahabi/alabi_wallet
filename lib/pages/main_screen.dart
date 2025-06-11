import 'package:daily_financial_recording/pages/dashboard.dart';
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF118EE0),
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 10,
            ),
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app_rounded),
                label: "Exit",
              ),
            ],
            onTap: (value) async {
              if (value == 1) {
                bool? confirmExit = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Exit Application"),
                        content: const Text("Are you sure you want to exit?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Exit"),
                          ),
                        ],
                      ),
                );

                if (confirmExit == true) {
                  Navigator.of(context).pop(); // Bisa juga pakai exit(0);
                }
              } else {
                setState(() {
                  _selectedIndex = value;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
