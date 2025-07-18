import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'onboarding_q3.dart'; // Import the next screen
import '../widgets/custom_back_button.dart';

class OnboardingQuestionTwoScreen extends StatefulWidget {
  final String answer1; // Changed from int to String
  final String userId; // Add userId parameter

  const OnboardingQuestionTwoScreen({
    super.key,
    required this.answer1,
    required this.userId, // Mark it as required
  });

  @override
  State<OnboardingQuestionTwoScreen> createState() =>
      _OnboardingQuestionTwoScreenState();
}

class _OnboardingQuestionTwoScreenState
    extends State<OnboardingQuestionTwoScreen> {
  int _selectedValue = -1; // Track the selected option

  // Map of index to actual text responses
  final Map<int, String> _responses = {
    0: 'Personal growth',
    1: 'Helping others',
    2: 'Achieving goals',
    3: 'Finding balance',
  };

  void _saveResponseAndContinue() async {
    if (_selectedValue == -1) return;

    try {
      // Save the actual text response to Firestore instead of the index
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('responses')
          .doc('question2')
          .set({'answer': _responses[_selectedValue]});

      // Navigate to the next onboarding question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => OnboardingQuestionThreeScreen(
                answer1:
                    widget.answer1, // Pass the actual text response from Q1
                answer2:
                    _responses[_selectedValue]!, // Pass the actual text response from Q2
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 126.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Color(0xFFE5E5F8),
                    child: Text(
                      '2',
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
                    'What motivates you the most right now?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'quicksand',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 0, text: 'Personal growth'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 1, text: 'Helping others'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 2, text: 'Achieving goals'),
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.center,
                    child: _buildOption(index: 3, text: 'Finding balance'),
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
            color: isSelected ? const Color(0xFF535394) : Colors.white,
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
                  fontWeight: FontWeight.w500,
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
