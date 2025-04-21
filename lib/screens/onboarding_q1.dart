import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_q2.dart';

class OnboardingQuestionOneScreen extends StatefulWidget {
  final String name;
  final String age;
  final String occupation;
  final String email;
  final String password;
  final String userId;

  const OnboardingQuestionOneScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.occupation,
    required this.email,
    required this.password,
    required this.userId,
  }) : super(key: key);

  @override
  State<OnboardingQuestionOneScreen> createState() =>
      _OnboardingQuestionOneScreenState();
}

class _OnboardingQuestionOneScreenState
    extends State<OnboardingQuestionOneScreen> {
  int _selectedValue = -1;

  void _saveResponseAndContinue() async {
    if (_selectedValue == -1) return;

    try {
      // Save the response to Firestore under the same UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('responses')
          .doc('question1')
          .set({'answer': _selectedValue});

      // Navigate to the next onboarding question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnboardingQuestionTwoScreen(
                answer1: _selectedValue,
                userId: widget.userId, // Pass the UID
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving response: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context);
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
            const CircleAvatar(
              radius: 24.0,
              backgroundColor: Color(0xFFE0E0E0),
              child: Text(
                '1',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'When life gets overwhelming, you usually...',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24.0),
            _buildOption(index: 0, text: 'Reflect quietly'),
            const SizedBox(height: 8.0),
            _buildOption(index: 1, text: 'Reach out'),
            const SizedBox(height: 8.0),
            _buildOption(index: 2, text: 'Power through'),
            const SizedBox(height: 8.0),
            _buildOption(index: 3, text: 'Distract yourself'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedValue == -1 ? null : _saveResponseAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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

  Widget _buildOption({required int index, required String text}) {
    final bool isSelected = _selectedValue == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = index;
        });
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : Colors.black45,
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
