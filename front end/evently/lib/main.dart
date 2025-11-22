import 'package:evently/presentation/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evently/logic/auth_bloc/auth_bloc.dart';
import 'package:evently/data/repo/auth/auth_repo.dart';
import 'package:evently/data/sources/auth/auth_remote.dart';

void main() {
  final authRepo = AuthRepo(AuthRemote()); // Initialize your repository
  runApp(MainApp(authRepo: authRepo));
}

class MainApp extends StatelessWidget {
  final AuthRepo authRepo;

  const MainApp({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepo),
        ),
        // You can add more BlocProviders here in the future
        // BlocProvider<AnotherBloc>(create: (_) => AnotherBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const Splash(),
      ),
    );
  }
}
