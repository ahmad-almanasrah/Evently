import 'package:evently/data/services/friends_service.dart';
import 'package:evently/data/services/home-service.dart';
import 'package:evently/data/services/profile_service.dart';
import 'package:evently/presentation/auth/login/login.dart';
import 'package:evently/presentation/auth/signup/signup.dart';
import 'package:evently/presentation/explore/feed.dart';
import 'package:evently/presentation/home/create_event_screen.dart';
import 'package:evently/presentation/home/event_details_screen.dart';
import 'package:evently/presentation/home/friend_search.dart';
import 'package:evently/presentation/home/home.dart';
import 'package:evently/presentation/home_layout/home_layout.dart';
import 'package:evently/presentation/profile/profile.dart';
import 'package:evently/providers/auth/login-provider.dart';
import 'package:evently/providers/auth/signup-provider.dart';
import 'package:evently/data/services/auth/auth_service.dart';
import 'package:evently/providers/friend-provider.dart';
import 'package:evently/providers/home-provider.dart';
import 'package:evently/providers/profile-provider.dart' as profile_provider;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async main

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Error loading .env file: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => LoginProvider(AuthService())),
        ChangeNotifierProvider(
          create: (_) => profile_provider.ProfileProvider(
            profileService: ProfileService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider(HomeService())),
        ChangeNotifierProvider(
          create: (_) => FriendProvider(friendService: FriendService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evently',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,

      // Default Starting Screen
      home: const Login(),

      // 1. Static Routes (No arguments needed)
      routes: {
        'Home': (context) => const Home(),
        'CreateEvent': (context) => const CreateEventScreen(),
        'Feed': (context) => const FeedScreen(),
        'Profile': (context) => Profile(toggleTheme: toggleTheme),
        'Login': (context) => const Login(),
        'HomeLayout': (context) => HomeLayout(toggleTheme: toggleTheme),
        'SignUp': (context) => const Signup(),
        'Friends': (context) => const FindFriendsScreen(),
      },

      // 2. Dynamic Routes (Handles the eventId argument)
      onGenerateRoute: (settings) {
        // ✅ Matches 'EventDetails' from your feed.dart push call
        if (settings.name == 'EventDetails') {
          final args = settings.arguments;

          if (args is int) {
            return MaterialPageRoute(
              builder: (context) => EventDetailsScreen(eventId: args),
            );
          }
        }
        return null;
      },
    );
  }
}
