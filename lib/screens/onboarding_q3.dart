import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodie_v2/screens/success_screen.dart';
import '../widgets/custom_back_button.dart';

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
      print('Error saving data: $e');
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
        leading: CustomBackButton(iconColor: Colors.black87, iconSize: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 126.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              radius: 24.0,
              backgroundColor: Color(0xFFE0E0E0),
              child: Text(
                '3',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'quicksand',
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Anything else you\'d like to tell?',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'quicksand',
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _additionalContextController,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'quicksand',
                  letterSpacing: -1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'What are your likes and dislikes?',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(137, 146, 139, 139),
                    fontFamily: 'quicksand',
                    letterSpacing: -1.5,
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF9F7AEA),
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7D7DDE),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
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
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1.5,
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
