import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Tela inicial
      initialRoute: '/login',

      // Rotas do app
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/camera': (context) => const CameraScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}