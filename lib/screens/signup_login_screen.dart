import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'enter_info.dart';
import 'package:moodie_v2/screens/login_screen.dart'; // Import the LoginScreen

class SignupLoginScreen extends StatelessWidget {
  const SignupLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            const Text(
              'Welcome to moodie',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'quicksand',
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is your space—let\'s make it feel like home. You won\'t even need an email, just sign up and get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'General Sans',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 30),
            SvgPicture.asset(
              'assets/images/Enthusiastic-pana.svg',
              height: 364,
              width: 364,
            ),
            const SizedBox(height: 18),

            // Create account button with anonymous login
            SizedBox(
              width: 364,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInAnonymously();
                    print(
                      "Anonymous sign-in successful: ${userCredential.user?.uid}",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EnterInfoScreen(),
                      ),
                    );
                  } catch (e) {
                    print("Error signing in anonymously: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to sign in anonymously."),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C84F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Log in button
            SizedBox(
              width: 364,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  print('Navigating to LoginScreen...');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none, // Remove outline
                  backgroundColor: const Color(
                    0xFFF8F7FF,
                  ), // White background for contrast
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ), // Adjusted padding
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    color: Color(0xFF2B2930),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Or sign up using:',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    color: Color(0xFF2B2930),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildSocialButton(
                  icon: 'assets/icons/icon-google.png',
                  onPressed: () => print('Sign up with Google'),
                ),
                _buildSocialButton(
                  icon: 'assets/icons/icon-apple.png',
                  onPressed: () => print('Sign up with Apple'),
                ),
                _buildSocialButton(
                  icon: 'assets/icons/icon-github.png',
                  onPressed: () => print('Sign up with Github'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _buildSocialButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(icon, height: 30, width: 30),
      ),
    );
  }
}
