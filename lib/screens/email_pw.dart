import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_q1.dart';
import '../widgets/custom_back_button.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String name;
  final String age;
  final String occupation;

  const EmailPasswordScreen({
    super.key,
    required this.name,
    required this.age,
    required this.occupation,
  });

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _linkAnonymousAccount() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('No anonymous user found');
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      UserCredential userCredential = await currentUser.linkWithCredential(
        credential,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': widget.name,
            'age': widget.age,
            'occupation': widget.occupation,
            'email': email,
          });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnboardingQuestionOneScreen(
                name: widget.name,
                age: widget.age,
                occupation: widget.occupation,
                email: email,
                password: password,
                userId: userCredential.user!.uid,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 176.0),
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                          fontFamily: 'quicksand',
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Let\'s get you set up with a secure account to keep your journey private and personal.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A5568),
                          fontFamily: 'General Sans',
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email field
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A5568),
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    fontFamily: 'General Sans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'you@example.com',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontFamily: 'General Sans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 0.2,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF9F7AEA),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBBB3FF),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A5568),
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(
                                    fontFamily: 'General Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Create a strong password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontFamily: 'General Sans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 0.2,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF9F7AEA),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFBBB3FF),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Use at least 8 characters with letters and numbers',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                        fontFamily: 'General Sans',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Next button
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFF7D7DDE),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _linkAnonymousAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Continue Your Journey',
                              style: TextStyle(
                                fontFamily: 'General Sans',
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ], // End of Column children
                  ), // Close Column
                ), // Close SingleChildScrollView
              ),
              // Custom back arrow positioned at top 12.0px and left 3px
              Positioned(
                top: 12.0,
                left: 3,
                child: CustomBackButton(
                  iconColor: const Color(0xFF2D3748),
                  iconSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
