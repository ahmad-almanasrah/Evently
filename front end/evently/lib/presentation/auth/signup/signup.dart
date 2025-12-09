// import 'package:evently/data/repo/auth/signup_repo.dart';
// import 'package:evently/data/sources/auth/signup_service.dart';
// import 'package:evently/presentation/auth/signup/signup_bloc.dart';
// import 'package:evently/presentation/auth/signup/signup_event.dart';
// import 'package:evently/presentation/auth/signup/signup_state.dart';
// import 'package:evently/presentation/auth/login/login.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class Signup extends StatefulWidget {
//   const Signup({super.key});

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//   final Color primaryColor = const Color(0xFF101127);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => SignupBloc(SignupRepo(signupService: SignupService())),
//       child: Scaffold(
//         backgroundColor: primaryColor,
//         resizeToAvoidBottomInset: true,
//         body: BlocListener<SignupBloc, SignupState>(
//           listener: (context, state) {
//             if (state is SignupSuccess) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const Login()),
//               );
//             }
//           },
//           child: Column(
//             children: [
//               // --- TOP SECTION ---
//               Container(
//                 padding: const EdgeInsets.only(top: 60, bottom: 20),
//                 width: double.infinity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       'assets/images/logo.svg',
//                       width: 80,
//                       placeholderBuilder: (context) => const Icon(
//                         Icons.image,
//                         size: 80,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Register',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Create your new account',
//                       style: TextStyle(fontSize: 16, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),

//               // --- BOTTOM SECTION ---
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: SingleChildScrollView(
//                       child: BlocBuilder<SignupBloc, SignupState>(
//                         builder: (context, state) {
//                           final isError = state is SignupError;
//                           final errorText = isError ? state.message : '';

//                           return Column(
//                             children: [
//                               const SizedBox(height: 20),

//                               // Username
//                               TextField(
//                                 controller: usernameController,
//                                 keyboardType: TextInputType.text,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.person_outline,
//                                       color: Colors.grey[600]),
//                                   labelText: 'Username',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: isError &&
//                                               errorText.contains("Username")
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Email
//                               TextField(
//                                 controller: emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.email_outlined,
//                                       color: Colors.grey[600]),
//                                   labelText: 'Email',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color:
//                                           isError && errorText.contains("Email")
//                                               ? Colors.red
//                                               : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Password
//                               TextField(
//                                 controller: passwordController,
//                                 obscureText: !isPasswordVisible,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.lock_outline,
//                                       color: Colors.grey[600]),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       isPasswordVisible
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: Colors.grey[600],
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isPasswordVisible = !isPasswordVisible;
//                                       });
//                                     },
//                                   ),
//                                   labelText: 'Password',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: isError &&
//                                               errorText.contains("Password")
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Confirm Password
//                               TextField(
//                                 controller: confirmPasswordController,
//                                 obscureText: !isConfirmPasswordVisible,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.lock_outline,
//                                       color: Colors.grey[600]),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       isConfirmPasswordVisible
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: Colors.grey[600],
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isConfirmPasswordVisible =
//                                             !isConfirmPasswordVisible;
//                                       });
//                                     },
//                                   ),
//                                   labelText: 'Confirm Password',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: isError &&
//                                               errorText.contains("Passwords")
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 30),

//                               // CREATE ACCOUNT BUTTON
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: state is SignupLoading
//                                       ? null
//                                       : () {
//                                           final username =
//                                               usernameController.text.trim();
//                                           final email =
//                                               emailController.text.trim();
//                                           final password =
//                                               passwordController.text.trim();
//                                           final confirmPassword =
//                                               confirmPasswordController.text
//                                                   .trim();

//                                           context.read<SignupBloc>().add(
//                                                 SignupButtonPressed(
//                                                   username: username,
//                                                   email: email,
//                                                   password: password,
//                                                   confirmPassword:
//                                                       confirmPassword,
//                                                 ),
//                                               );
//                                         },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryColor,
//                                     shadowColor: primaryColor,
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   child: state is SignupLoading
//                                       ? const CircularProgressIndicator(
//                                           color: Colors.white)
//                                       : const Text(
//                                           'Create Account',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // LOGIN LINK
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Already have an account? ",
//                                     style: TextStyle(color: Colors.grey[600]),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                             builder: (_) => const Login()),
//                                       );
//                                     },
//                                     child: Text(
//                                       "Login",
//                                       style: TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               // ERROR DISPLAY
//                               if (isError)
//                                 Container(
//                                   margin: const EdgeInsets.only(top: 12),
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.shade100,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.error_outline,
//                                           color: Colors.red),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           errorText,
//                                           style: const TextStyle(
//                                               color: Colors.red, fontSize: 14),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:evently/data/repo/auth/signup_repo.dart';
import 'package:evently/data/sources/auth/signup_service.dart';
import 'package:evently/presentation/auth/signup/signup_cubit.dart';
import 'package:evently/presentation/auth/signup/signup_state.dart';
import 'package:evently/presentation/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // Exact color from your Login screen
  final Color primaryColor = const Color(0xFF101127);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(SignupRepo(signupService: SignupService())),
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            }
          },
          builder: (context, state) {
            String? errorMessage;
            bool isError = false;

            if (state is SignupError) {
              errorMessage = state.message;
              isError = true;
            }

            return Column(
              children: [
                // --- TOP SECTION (Matches Login Style) ---
                Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 80,
                        placeholderBuilder: (context) => const Icon(Icons.image,
                            size: 80, color: Colors.white),
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

                // --- BOTTOM SECTION (White Container with Radius 30) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // First & Last Name
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: firstNameController,
                                    decoration: _buildInputDecoration(
                                      label: 'First Name',
                                      icon: Icons.person_outline,
                                      isError: isError,
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
                                      isError: isError,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Username
                            TextField(
                              controller: usernameController,
                              decoration: _buildInputDecoration(
                                label: 'Username',
                                icon: Icons.person_outline,
                                isError: isError,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration(
                                label: 'Email',
                                icon: Icons.email_outlined,
                                isError: isError,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextField(
                              controller: passwordController,
                              obscureText: !isPasswordVisible,
                              decoration: _buildInputDecoration(
                                label: 'Password',
                                icon: Icons.lock_outline,
                                isError: isError,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: !isConfirmPasswordVisible,
                              decoration: _buildInputDecoration(
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                isError: isError,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isConfirmPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isConfirmPasswordVisible =
                                          !isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // --- ERROR BOX (Bottom) ---
                            if (errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // --- BUTTON (Matches Login Button Style) ---
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (state is! SignupLoading) {
                                    context.read<SignupCubit>().signup(
                                          usernameController.text.trim(),
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                          firstNameController.text.trim(),
                                          lastNameController.text.trim(),
                                        );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shadowColor: primaryColor,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: state is SignupLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Create Account',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const Login()),
                                    );
                                  },
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Exact styling from Login: Grey[50], Radius 16, Grey[600] text/icons
  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required bool isError,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      // Login used suffixIcon for the icon, but usually inputs use prefix.
      // I kept prefix here for Signup standard, but kept colors exact.
      suffixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : primaryColor,
        ),
      ),
    );
  }
}
