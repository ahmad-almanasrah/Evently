import 'package:evently/presentation/auth/login/login.dart';
import 'package:evently/presentation/auth/signup/signup.dart';
import 'package:evently/presentation/home_layout/home_layout.dart';
import 'package:evently/presentation/profile/profile.dart';
import 'package:evently/presentation/splash/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        // '/forgot_password': (context) => const Forgot_z(),
        '/home': (context) => const HomeLayout(),
        '/profile': (context) => const Profile(),
      },
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Splash(),
    );
  }
}
