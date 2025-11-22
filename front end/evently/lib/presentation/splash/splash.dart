import 'dart:async'; // Used for the navigation timer
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Import the Login Page
import 'package:evently/presentation/auth/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

// 'with SingleTickerProviderStateMixin' is required for the AnimationController
class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // How long one full spin takes
      vsync: this,
    )..repeat(); // Makes the animation spin forever

    // 2. Define the animation curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // A constant, non-slowing spin
    );

    // 3. Set up the navigation timer
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Timer(
      const Duration(seconds: 3), // How long the splash screen stays visible
      () {
        // Check if the widget is still in the tree to avoid errors
        if (!mounted) return;

        // Use pushReplacement to prevent the user from "going back"
        // to the splash screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(), // <-- Navigate to Login
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Always dispose of controllers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic app layout structure
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        252,
        252,
        252,
      ), // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- 1. The Spinning Logo ---
            // This widget handles the actual rotation
            RotationTransition(
              turns: _animation,
              child: SvgPicture.asset(
                'assets/images/logo.svg', // Your asset path
                width: 150, // You can adjust the logo size here
                // Add a fallback in case the SVG isn't found yet
                placeholderBuilder: (BuildContext context) =>
                    const Icon(Icons.image, size: 150, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24), // Provides spacing
            // --- 2. The Static Text ---
            // This Text widget is *outside* the RotationTransition,
            // so it will not spin.
            const Text(
              "evently",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Choose your text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
