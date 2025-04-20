import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuccessScreen extends StatefulWidget {
  final Map<String, dynamic> userAnswers; // Pass answers from onboarding

  SuccessScreen({required this.userAnswers});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveDataToFirebase();
  }

  Future<void> _saveDataToFirebase() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Sign in anonymously
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      String uid = userCredential.user!.uid;

      // Save user answers to Firestore
      await FirebaseFirestore.instance
          .collection('onboarding_responses')
          .doc(uid)
          .set({
            'uid': uid,
            'answers': widget.userAnswers,
            'timestamp': Timestamp.now(),
          });

      print('Data saved for UID: $uid');
    } catch (e) {
      print('Error saving data: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSaving)
                CircularProgressIndicator()
              else ...[
                Text(
                  "That was brave.\nWell Done!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.0),
                Image.asset(
                  'assets/images/img4.png', // make sure this is in pubspec.yaml
                  height: 324,
                  width: 324,
                ),
                SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to home or dashboard screen
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    icon: Icon(Icons.lightbulb_outline),
                    label: Text("Start Your Journey"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[300],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
