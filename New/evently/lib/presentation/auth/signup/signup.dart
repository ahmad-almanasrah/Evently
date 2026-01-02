import 'package:evently/providers/auth/signup-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final Color primaryColor = const Color(0xFF101127);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: Consumer<SignupProvider>(
        builder: (context, signupProvider, child) {
          // ✅ FIX: Handle Success and Errors safely using postFrameCallback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (signupProvider.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(signupProvider.errorMessage!)),
              );
              signupProvider
                  .clearError(); // Important: clear the error after showing it
            }

            if (signupProvider.signupSuccess) {
              Navigator.pop(context);
              // You might want to clear the success flag in the provider here too
            }
          });

          return Stack(
            children: [
              // --- TOP SECTION (30% Height) ---
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * 0.35,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: size.height * 0.1,
                        placeholderBuilder: (context) => Icon(
                          Icons.image,
                          size: size.height * 0.1,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your new account',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              // --- BOTTOM SECTION (White Sheet) ---
              Positioned(
                top: size.height * 0.32,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

                              // --- FIRST & LAST NAME ---
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: firstNameController,
                                      decoration: _buildInputDecoration(
                                        label: 'First Name',
                                        icon: Icons.person_outline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller: lastNameController,
                                      decoration: _buildInputDecoration(
                                        label: 'Last Name',
                                        icon: Icons.person_outline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- USERNAME ---
                              TextField(
                                controller: usernameController,
                                decoration: _buildInputDecoration(
                                  label: 'Username',
                                  icon: Icons.person_outline,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- EMAIL ---
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _buildInputDecoration(
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- PASSWORD ---
                              TextField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration:
                                    _buildInputDecoration(
                                      label: 'Password',
                                      icon: Icons.lock_outline,
                                    ).copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () => setState(
                                          () => isPasswordVisible =
                                              !isPasswordVisible,
                                        ),
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 16),

                              // --- CONFIRM PASSWORD ---
                              TextField(
                                controller: confirmPasswordController,
                                obscureText: !isConfirmPasswordVisible,
                                decoration:
                                    _buildInputDecoration(
                                      label: 'Confirm Password',
                                      icon: Icons.lock_outline,
                                    ).copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isConfirmPasswordVisible
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () => setState(
                                          () => isConfirmPasswordVisible =
                                              !isConfirmPasswordVisible,
                                        ),
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 24),

                              // --- CREATE ACCOUNT BUTTON ---
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: signupProvider.isLoading
                                      ? null
                                      : () {
                                          signupProvider.signup(
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            username: usernameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            confirmPassword:
                                                confirmPasswordController.text,
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: signupProvider.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- LOGIN LINK ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      suffixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
