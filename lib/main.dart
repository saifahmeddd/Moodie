// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/success_screen.dart';
import 'screens/mood_checkin_screen.dart';
import 'screens/home_page.dart' as Home;
import 'screens/profile_screen.dart';
import 'screens/mood_tracker.dart';
import 'chatbot_screen.dart';
import 'screens/journaling_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/breathing_exercises_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      // Use AuthGate as the home widget
      home: const AuthGate(),
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
            return MaterialPageRoute(builder: (_) => const MoodTrackerScreen());
          case '/chatbot':
            return MaterialPageRoute(builder: (_) => const ChatbotScreen());
          case '/journaling':
            return MaterialPageRoute(builder: (_) => JournalingScreen());
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
      routes: {
        '/mood': (context) => const MoodTrackerScreen(),
        '/exercises': (context) => const BreathingExercisesScreen(),
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

// Add AuthGate widget
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash while waiting for auth state
          return const SplashScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in
          return const Home.HomePage();
        } else {
          // Not logged in
          return const SplashScreen();
        }
      },
    );
  }
}
