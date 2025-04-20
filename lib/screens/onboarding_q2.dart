import 'package:flutter/material.dart';
import 'onboarding_q3.dart'; // Import the next screen

class OnboardingQuestionTwoScreen extends StatefulWidget {
  final int answer1; // Parameter to accept the answer from Question 1

  const OnboardingQuestionTwoScreen({
    Key? key,
    required this.answer1, // Mark it as required
  }) : super(key: key);

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
        title: const Text(
          'Onboarding Question 2',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: false,
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
                '2',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
              ),
            ),
            const SizedBox(height: 24.0),
            // Display the answer from Question 1
            Text(
              'Your answer from Question 1: ${widget.answer1}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),
            _buildOption(index: 0, text: 'Personal growth'),
            const SizedBox(height: 8.0),
            _buildOption(index: 1, text: 'Helping others'),
            const SizedBox(height: 8.0),
            _buildOption(index: 2, text: 'Achieving goals'),
            const SizedBox(height: 8.0),
            _buildOption(index: 3, text: 'Finding balance'),
            const Spacer(),
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
                                    answer1: widget.answer1,
                                    answer2: _selectedValue,
                                  ),
                            ),
                          );
                        },
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
          _selectedValue = index; // Update the selected option
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
