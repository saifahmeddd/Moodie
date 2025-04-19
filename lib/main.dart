import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoodieApp());
}

class MoodieApp extends StatelessWidget {
  const MoodieApp({super.key});

  Future<FirebaseApp> _initFirebase() async {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDcIukFX9q-jCNJS-HNAmOuMy5J2ZYxSbs",
        authDomain: "moodie-v2.firebaseapp.com",
        projectId: "moodie-v2",
        storageBucket: "moodie-v2.appspot.com",
        messagingSenderId: "942104383253",
        appId: "1:942104383253:android:0792c355403193f70ba31c",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodie App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _initFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          } else if (snapshot.hasError) {
            return Center(child: Text("Firebase Error: ${snapshot.error}"));
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
