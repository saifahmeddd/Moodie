import 'package:flutter/material.dart';
import 'onboarding_q3.dart'; // Import the next screen

class OnboardingQuestionTwoScreen extends StatefulWidget {
  final int answer1; // Parameter to accept the answer from Question 1

  const OnboardingQuestionTwoScreen({
    super.key,
    required this.answer1,
    required String userId, // Mark it as required
  });

  @override
  State<OnboardingQuestionTwoScreen> createState() =>
      _OnboardingQuestionTwoScreenState();
}

class _OnboardingQuestionTwoScreenState
    extends State<OnboardingQuestionTwoScreen> {
  int _selectedValue = -1; // Track the selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'quicksand',
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 32.0),
            _buildOption(index: 0, text: 'Personal growth'),
            const SizedBox(height: 16.0),
            _buildOption(index: 1, text: 'Helping others'),
            const SizedBox(height: 16.0),
            _buildOption(index: 2, text: 'Achieving goals'),
            const SizedBox(height: 16.0),
            _buildOption(index: 3, text: 'Finding balance'),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedValue == -1
                        ? null // Disable the button if no option is selected
                        : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OnboardingQuestionThreeScreen(
                                    answer1: widget.answer1, // Pass answer1
                                    answer2: _selectedValue, // Pass answer2
                                  ),
                            ),
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
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
                        fontSize: 18.0,
                        fontFamily: 'quicksand',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                      ),
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
          _selectedValue = index; // Update the selected option
        });
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? Colors.deepPurpleAccent.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.3),
              blurRadius: isSelected ? 12.0 : 8.0,
              spreadRadius: isSelected ? 1.5 : 1.0,
            ),
          ],
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
                fontFamily: 'quicksand',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: -1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
