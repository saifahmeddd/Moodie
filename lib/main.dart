// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/success_screen.dart';
import 'screens/mood_checkin_screen.dart';
import 'screens/home_page.dart' as Home;
import 'screens/profile_screen.dart'; // Import the ProfileScreen
import 'screens/mood_tracker.dart'; // Import the MoodTracker screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MoodieApp());
}

class MoodieApp extends StatelessWidget {
  const MoodieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodie App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/mood-checkin':
            return MaterialPageRoute(builder: (_) => const MoodCheckinScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const Home.HomePage());
          case '/profile': // Route for ProfileScreen
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/mood-tracker': // Route for MoodTracker screen
            return MaterialPageRoute(builder: (_) => const MoodTrackerApp());
          case '/success':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('userAnswers')) {
              return MaterialPageRoute(
                builder: (_) => SuccessScreen(userAnswers: args['userAnswers']),
              );
            }
            return _errorRoute(
              "Missing userAnswers argument for SuccessScreen.",
            );
          default:
            return _errorRoute("No route defined for ${settings.name}");
        }
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(message)),
          ),
    );
  }
}
