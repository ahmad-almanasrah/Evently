// import 'package:evently/data/repo/auth/login_repo.dart';
// import 'package:evently/data/sources/auth/login_service.dart';

// import 'package:evently/presentation/auth/login/login_bloc.dart';
// import 'package:evently/presentation/auth/login/login_event.dart';
// import 'package:evently/presentation/auth/login/login_state.dart';
// import 'package:evently/presentation/auth/signup/signup.dart';
// import 'package:evently/presentation/home_layout/home_layout.dart';
// import 'package:evently/presentation/profile/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   bool isPasswordVisible = false;
//   bool obscureTextValue = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF101127);

//     return BlocProvider(
//       create: (_) => LoginBloc(LoginRepo(LoginService())),
//       child: Scaffold(
//         backgroundColor: primaryColor,
//         resizeToAvoidBottomInset: true,
//         body: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             // if (state is LoginError) {
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(content: Text(state.error)),
//             //   );
//             // }

//             if (state is LoginSuccess) {
//               FocusScope.of(context).unfocus();

//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => const Profile()));
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
//                       placeholderBuilder: (BuildContext context) => const Icon(
//                           Icons.image,
//                           size: 80,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Please enter your credentials.',
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
//                       child: BlocBuilder<LoginBloc, LoginState>(
//                         builder: (context, state) {
//                           return Column(
//                             children: [
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   suffixIcon: Icon(Icons.email_outlined,
//                                       color: Colors.grey[600]),
//                                   labelText: 'Email',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: state is LoginError
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               TextField(
//                                 controller: passwordController,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 obscureText: obscureTextValue,
//                                 decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         isPasswordVisible = !isPasswordVisible;
//                                         obscureTextValue = !isPasswordVisible;
//                                       });
//                                     },
//                                     icon: Icon(
//                                       isPasswordVisible
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   labelText: 'Password',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: state is LoginError
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                   onPressed: () => {
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const HomeLayout(),
//                                       ),
//                                     )
//                                   },
//                                   child: const Text(
//                                     'Forgot Password?',
//                                     style: TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               if (state is LoginLoading)
//                                 const LinearProgressIndicator(),
//                               const SizedBox(height: 16),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     BlocProvider.of<LoginBloc>(context).add(
//                                       LoginButtonPressed(
//                                         email: emailController.text.trim(),
//                                         password:
//                                             passwordController.text.trim(),
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryColor,
//                                     shadowColor: primaryColor,
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Login',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Don't have an account? ",
//                                     style: TextStyle(color: Colors.grey[600]),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Signup()),
//                                       );
//                                     },
//                                     child: const Text(
//                                       "Sign Up",
//                                       style: TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               BlocBuilder<LoginBloc, LoginState>(
//                                 builder: (context, state) {
//                                   if (state is LoginError) {
//                                     return Container(
//                                       margin: const EdgeInsets.only(top: 12),
//                                       padding: const EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.shade100,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.error_outline,
//                                               color: Colors.red),
//                                           const SizedBox(width: 8),
//                                           Expanded(
//                                             child: Text(
//                                               state.error.toString(),
//                                               style: const TextStyle(
//                                                   color: Colors.red,
//                                                   fontSize: 14),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                   return const SizedBox
//                                       .shrink(); // empty space when no error
//                                 },
//                               ),
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

// import 'package:evently/data/repo/auth/login_repo.dart';
// import 'package:evently/data/sources/auth/login_service.dart';

// import 'package:evently/presentation/auth/login/login_cubit.dart';
// import 'package:evently/presentation/auth/login/login_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   bool isPasswordVisible = false;
//   bool obscureTextValue = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF101127);

//     return BlocProvider(
//       create: (_) => LoginCubit(LoginRepo(LoginService())),
//       child: Scaffold(
//         backgroundColor: primaryColor,
//         resizeToAvoidBottomInset: true,
//         body: BlocListener<LoginCubit, LoginState>(
//           listener: (context, state) {
//             if (state is LoginSuccess) {
//               FocusScope.of(context).unfocus();
//               Navigator.pushReplacementNamed(context, '/home');
//             }
//           },
//           child: Column(
//             children: [
//               // --- TOP SECTION (UNCHANGED) ---
//               Container(
//                 padding: const EdgeInsets.only(top: 60, bottom: 20),
//                 width: double.infinity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       'assets/images/logo.svg',
//                       width: 80,
//                       placeholderBuilder: (BuildContext context) => const Icon(
//                           Icons.image,
//                           size: 80,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Please enter your credentials.',
//                       style: TextStyle(fontSize: 16, color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),

//               // --- BOTTOM SECTION (UNCHANGED LAYOUT) ---
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
//                       child: BlocBuilder<LoginCubit, LoginState>(
//                         builder: (context, state) {
//                           return Column(
//                             children: [
//                               const SizedBox(height: 20),

//                               // --- EMAIL INPUT ---
//                               TextField(
//                                 controller: emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   suffixIcon: Icon(Icons.email_outlined,
//                                       color: Colors.grey[600]),
//                                   labelText: 'Email',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: state is LoginError
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // --- PASSWORD INPUT ---
//                               TextField(
//                                 controller: passwordController,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 obscureText: obscureTextValue,
//                                 decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         isPasswordVisible = !isPasswordVisible;
//                                         obscureTextValue = !isPasswordVisible;
//                                       });
//                                     },
//                                     icon: Icon(
//                                       isPasswordVisible
//                                           ? Icons.visibility_off_outlined
//                                           : Icons.visibility_outlined,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   labelText: 'Password',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: state is LoginError
//                                           ? Colors.red
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                 ),
//                               ),

//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                   onPressed: () {
//                                     Navigator.pushNamed(context, '/home');
//                                   },
//                                   child: const Text(
//                                     'Forgot Password?',
//                                     style: TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Remove the old LinearProgressIndicator here since we moved it to the button

//                               const SizedBox(height: 16),

//                               // --- THE LOGIN BUTTON (UPDATED) ---
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     // Prevent clicking while loading
//                                     if (state is! LoginLoading) {
//                                       context.read<LoginCubit>().login(
//                                             emailController.text.trim(),
//                                             passwordController.text.trim(),
//                                           );
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: primaryColor,
//                                     shadowColor: primaryColor,
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   // --- CHANGE IS HERE ---
//                                   child: state is LoginLoading
//                                       ? const SizedBox(
//                                           height: 24,
//                                           width: 24,
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                             strokeWidth: 3,
//                                           ),
//                                         )
//                                       : const Text(
//                                           'Login',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                 ),
//                               ),

//                               const SizedBox(height: 16),

//                               // --- SIGN UP LINK ---
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Don't have an account? ",
//                                     style: TextStyle(color: Colors.grey[600]),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.pushNamed(context, '/signup');
//                                     },
//                                     child: const Text(
//                                       "Sign Up",
//                                       style: TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               // --- ERROR BOX ---
//                               if (state is LoginError)
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
//                                           state.error.toString(),
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

import 'package:evently/data/repo/auth/login_repo.dart';
import 'package:evently/data/sources/auth/login_service.dart';
import 'package:evently/presentation/auth/login/login_cubit.dart';
import 'package:evently/presentation/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  bool obscureTextValue = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Color primaryColor = const Color(0xFF101127);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(LoginRepo(LoginService())),
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: true,
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: Column(
            children: [
              // --- TOP SECTION ---
              Container(
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 80,
                      placeholderBuilder: (BuildContext context) => const Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please enter your credentials.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // --- BOTTOM SECTION ---
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
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          // FIX: Check if we are in an error state
                          final bool isError = state is LoginError;

                          return Column(
                            children: [
                              const SizedBox(height: 20),

                              // --- EMAIL INPUT ---
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

                              // --- PASSWORD INPUT ---
                              TextField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obscureTextValue,
                                decoration: _buildInputDecoration(
                                  label: 'Password',
                                  icon: isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  isError: isError,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                        obscureTextValue = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/home');
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // --- LOGIN BUTTON ---
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (state is! LoginLoading) {
                                      context.read<LoginCubit>().login(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
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
                                  child: state is LoginLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // --- SIGN UP LINK ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // --- ERROR BOX ---
                              if (isError)
                                Container(
                                  margin: const EdgeInsets.only(top: 12),
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
                                          state.error.toString(),
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FIX: This helper ensures the border is RED even when you click (Focus) the field
  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required bool isError,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      suffixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[50],
      // Border when idle
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : Colors.grey,
        ),
      ),
      // Border when typing (focused)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : primaryColor,
        ),
      ),
      // Fallback border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isError ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
