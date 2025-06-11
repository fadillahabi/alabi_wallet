import 'package:daily_financial_recording/database/db_input.dart';
import 'package:daily_financial_recording/pages/dashboard.dart';
import 'package:daily_financial_recording/pages/filter.dart';
import 'package:daily_financial_recording/pages/login.dart';
import 'package:daily_financial_recording/pages/main_screen.dart';
import 'package:daily_financial_recording/pages/register.dart';
import 'package:daily_financial_recording/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBInput.deleteDatabaseFile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Open(),
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        DashboardUang.id: (context) => DashboardUang(),
        MainScreen.id: (context) => MainScreen(),
        FilterPage.id: (context) => FilterPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Alabi Wallet',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1E88E5),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
