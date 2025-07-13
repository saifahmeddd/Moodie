// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup_login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7D7DDE),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            const Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'moodie.',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'quicksand',
                        letterSpacing: -3.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stay in touch—with yourself',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'quicksand',
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Image Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 23.0),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/growth2.svg',
                    height: 313,
                    width: 313,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Button Section
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: 314,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Color(0xFF474D9F),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'GeneralSans',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
