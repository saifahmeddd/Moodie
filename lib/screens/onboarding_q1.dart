import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_q2.dart';
import '../widgets/custom_back_button.dart';

class OnboardingQuestionOneScreen extends StatefulWidget {
  final String name;
  final String age;
  final String occupation;
  final String email;
  final String password;
  final String userId;

  const OnboardingQuestionOneScreen({
    super.key,
    required this.name,
    required this.age,
    required this.occupation,
    required this.email,
    required this.password,
    required this.userId,
  });

  @override
  State<OnboardingQuestionOneScreen> createState() =>
      _OnboardingQuestionOneScreenState();
}

class _OnboardingQuestionOneScreenState
    extends State<OnboardingQuestionOneScreen> {
  int _selectedValue = -1;

  // Map of index to actual text responses
  final Map<int, String> _responses = {
    0: 'Reflect quietly',
    1: 'Reach out',
    2: 'Power through',
    3: 'Distract yourself',
  };

  void _saveResponseAndContinue() async {
    if (_selectedValue == -1) return;

    try {
      // Save the actual text response to Firestore instead of the index
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('responses')
          .doc('question1')
          .set({'answer': _responses[_selectedValue]});

      // Navigate to the next onboarding question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnboardingQuestionTwoScreen(
                answer1:
                    _responses[_selectedValue]!, // Pass the actual text response
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 126.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Color(0xFFE5E5F8),
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'quicksand',
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'When life gets overwhelming, you usually...',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'quicksand',
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 0, text: 'Reflect quietly'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 1, text: 'Reach out'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 2, text: 'Power through'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 3, text: 'Distract yourself'),
                  ),
                  const SizedBox(height: 48.0),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 364,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            _selectedValue == -1
                                ? null
                                : _saveResponseAndContinue,
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontFamily: 'General Sans',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom back arrow positioned at top 12.0px and left 3px
          Positioned(
            top: 12.0,
            left: 3,
            child: CustomBackButton(iconColor: Colors.black87, iconSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({required int index, required String text}) {
    final bool isSelected = _selectedValue == index;
    final Color purple = const Color(0xFF535394);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = index;
        });
      },
      borderRadius: BorderRadius.circular(12.0),
      child: SizedBox(
        width: 364,
        height: 45,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? purple : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border:
                isSelected
                    ? null
                    : Border.all(color: const Color(0xFFBBB3FF), width: 1),
            boxShadow:
                isSelected
                    ? []
                    : [
                      BoxShadow(
                        color: const Color(0x3D7B5CFA), // 24% opacity
                        blurRadius: 0,
                        spreadRadius: 3,
                        offset: Offset(0, 0),
                      ),
                    ],
          ),
          child: Row(
            children: <Widget>[
              isSelected
                  ? Icon(Icons.check, color: Colors.white)
                  : Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7D7DDE),
                      shape: BoxShape.circle,
                    ),
                  ),
              const SizedBox(width: 16.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13.0,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontFamily: 'General Sans',
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
