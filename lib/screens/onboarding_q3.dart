import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodie_v2/screens/success_screen.dart';

class OnboardingQuestionThreeScreen extends StatefulWidget {
  final int answer1;
  final int answer2;

  const OnboardingQuestionThreeScreen({
    super.key,
    required this.answer1,
    required this.answer2,
  });

  @override
  State<OnboardingQuestionThreeScreen> createState() =>
      _OnboardingQuestionThreeScreenState();
}

class _OnboardingQuestionThreeScreenState
    extends State<OnboardingQuestionThreeScreen> {
  final TextEditingController _additionalContextController =
      TextEditingController();
  bool _isLoading = false;

  void _navigateToPreviousScreen() {
    Navigator.of(context).pop();
  }

  Future<void> _handleFinish() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Get the currently signed-in user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is currently signed in");
      }

      String uid = currentUser.uid;

      String additionalText = _additionalContextController.text;

      // ✅ Save data to Firestore using the same UID
      await FirebaseFirestore.instance.collection('user_answers').doc(uid).set({
        'answer1': widget.answer1,
        'answer2': widget.answer2,
        'additional_context': additionalText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Saved answers for UID: $uid");

      // ✅ Navigate to SuccessScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => SuccessScreen(
                userAnswers: {
                  'answer1': widget.answer1.toString(),
                  'answer2': widget.answer2.toString(),
                  'additional_context': additionalText,
                },
              ),
        ),
      );
    } catch (e) {
      print('❌ Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToPreviousScreen,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.grey[200],
              child: const Text(
                '3',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Anything else you\'d like to tell?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            //const SizedBox(height: 24.0),
            // const Text(
            //   'Additional Context',
            //   style: TextStyle(fontSize: 16.0, color: Colors.black54),
            // ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _additionalContextController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'What are your likes and dislikes?',
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Finish',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Icon(Icons.check, color: Colors.white),
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
