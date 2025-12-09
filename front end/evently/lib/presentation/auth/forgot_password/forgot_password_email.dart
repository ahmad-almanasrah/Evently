// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// // --- IMPORTS FOR BLOC & REPO ---
// import 'package:evently/presentation/auth/forgot_password/forgot_password_event.dart';
// import 'package:evently/presentation/auth/forgot_password/forgot_password_state.dart';
// import 'package:evently/data/repo/auth/reset_password_repo.dart';
// import 'package:evently/data/repo/auth/reset_password_repo.dart';
// import 'package:evently/data/sources/auth/reset_password_service.dart';

// class ForgotPasswordEmail extends StatefulWidget {
//   const ForgotPasswordEmail({super.key});

//   @override
//   State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
// }

// class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
//   final TextEditingController emailController = TextEditingController();
//   final Color primaryColor = const Color(0xFF101127);

//   @override
//   Widget build(BuildContext context) {
//     // 1. WRAP EVERYTHING IN BLOC PROVIDER
//     return BlocProvider(
//       create: (context) => ForgotPasswordBloc(
//         repo: ResetPasswordRepo(
//           resetPasswordService: ResetPasswordService(), // Creates fresh service
//         ),
//       ),
//       // 2. NOW USE BLOC LISTENER AS CHILD
//       child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
//         listener: (context, state) {
//           if (state is ForgotPasswordOTPSent) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Reset link sent! Please check your email.'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.pop(context);
//           } else if (state is ForgotPasswordError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.error),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         // 3. BUILD THE UI (Builder context now sees the Bloc!)
//         child: Builder(
//           builder: (context) {
//             return Scaffold(
//               backgroundColor: primaryColor,
//               resizeToAvoidBottomInset: true,
//               appBar: AppBar(
//                 backgroundColor: primaryColor,
//                 elevation: 0,
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               body: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(bottom: 30),
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/images/logo.svg',
//                           width: 80,
//                           placeholderBuilder: (_) => const Icon(Icons.image,
//                               size: 80, color: Colors.white),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Enter your email to receive a reset link.',
//                           style: TextStyle(fontSize: 16, color: Colors.white70),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           topRight: Radius.circular(30),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 30),
//                               TextField(
//                                 controller: emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.email_outlined,
//                                       color: Colors.grey[700]),
//                                   labelText: 'Email',
//                                   labelStyle:
//                                       TextStyle(color: Colors.grey[600]),
//                                   filled: true,
//                                   fillColor: Colors.grey[50],
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                     borderSide: BorderSide(
//                                       color: primaryColor,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 30),

//                               // The Button listens to the Bloc provided above
//                               BlocBuilder<ForgotPasswordBloc,
//                                   ForgotPasswordState>(
//                                 builder: (context, state) {
//                                   if (state is ForgotPasswordLoading) {
//                                     return const Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   }
//                                   return SizedBox(
//                                     width: double.infinity,
//                                     height: 50,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         final email =
//                                             emailController.text.trim();
//                                         if (email.isEmpty) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                                 content: Text(
//                                                     "Please enter an email")),
//                                           );
//                                           return;
//                                         }
//                                         // Trigger Event
//                                         context.read<ForgotPasswordBloc>().add(
//                                             SendOTPButtonPressed(email: email));
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: primaryColor,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(16),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Send Reset Link",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
