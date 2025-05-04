import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'enter_info.dart';
import 'package:moodie_v2/screens/login_screen.dart'; // Import the LoginScreen

class SignupLoginScreen extends StatelessWidget {
  const SignupLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            const Text(
              'Welcome to moodie',
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'quicksand',
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -2.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is your space—let\'s make it feel like home. You won\'t even need an email, just sign up and get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'quicksand',
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 30),
            Image.asset('assets/images/img3.png', height: 364, width: 364),
            const SizedBox(height: 40),

            // Create account button with anonymous login
            SizedBox(
              width: double.infinity,
              height: 50,
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Log in button
            SizedBox(
              width: double.infinity,
              height: 50,
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
                  side: const BorderSide(color: Color(0xFF7C84F8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFF7C84F8),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Or sign up using:',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
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
