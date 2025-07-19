import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mood_checkin_screen.dart'; // Import the MoodCheckinScreen
import 'package:flutter_svg/flutter_svg.dart';

class SuccessScreen extends StatefulWidget {
  final Map<String, dynamic> userAnswers; // Pass answers from onboarding

  const SuccessScreen({super.key, required this.userAnswers});

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
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user signed in");
      }

      String uid = currentUser.uid;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save answers: $e")));
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
                const CircularProgressIndicator()
              else ...[
                const Text(
                  "That was brave.\nWell Done!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'quicksand',
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 24.0),
                SvgPicture.asset(
                  'assets/images/Self confidence-pana.svg',
                  height: 324,
                  width: 324,
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to MoodCheckinScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoodCheckinScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Start Your Journey",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7D7DDE),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
