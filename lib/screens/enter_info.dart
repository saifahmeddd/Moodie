import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'onboarding_q1.dart';

class EnterInfoScreen extends StatefulWidget {
  const EnterInfoScreen({super.key});

  @override
  State<EnterInfoScreen> createState() => _EnterInfoScreenState();
}

class _EnterInfoScreenState extends State<EnterInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveUserInfoAndProceed() async {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String occupation = _occupationController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty ||
        age.isEmpty ||
        occupation.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'age': age,
        'occupation': occupation,
        'email': email,
      });

      // Navigate to the next screen (Onboarding Question 1)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnboardingQuestionOneScreen(
                name: name,
                age: age,
                occupation: occupation,
                userId: '',
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'We\'ll use this information to personalize your experience and ensure you get suggestions suited to you.',
              style: TextStyle(fontSize: 14.0, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'First, what should we call you?',
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'How old are you?',
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Your age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'What do you do?',
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _occupationController,
              decoration: InputDecoration(
                hintText: 'Student / Engineer / Artist etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Email',
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveUserInfoAndProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
