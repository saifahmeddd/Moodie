import 'package:flutter/material.dart';

class SignupLoginScreen extends StatelessWidget {
  const SignupLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align all items to the left
          children: <Widget>[
            const SizedBox(height: 60),

            // Welcome Text
            const Text(
              'Welcome to moodie',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Sub Text
            const Text(
              'This is your space—let\'s make it feel like home. You won\'t even need an email, just sign up and get started',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Main image
            Image.asset('assets/images/img3.png', height: 364, width: 364),
            const SizedBox(height: 40),

            // Create account button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement create account functionality
                  print('Create an account pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C84F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
                  // TODO: Implement log in functionality
                  print('Log In pressed');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7C84F8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFF7C84F8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // OR Divider
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

            // Social login buttons
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
