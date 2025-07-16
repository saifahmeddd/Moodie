import 'package:flutter/material.dart';
import '../widgets/custom_back_button.dart';
import 'mood_checkin_complete_screen.dart'; // Added import for MoodCheckinCompleteScreen

class FactorsScreen extends StatefulWidget {
  const FactorsScreen({super.key});

  @override
  State<FactorsScreen> createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  final List<Map<String, dynamic>> factors = [
    {'text': 'Had a meaningful conversation with a friend', 'selected': true},
    {'text': 'Argued or disagreed with someone', 'selected': false},
    {'text': 'Completed an important task or goal', 'selected': false},
    {'text': 'Felt tired or didn\'t sleep well', 'selected': false},
    {'text': 'Had an unexpected problem or setback', 'selected': false},
  ];

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: CustomBackButton(
                  iconColor: Colors.black87,
                  iconSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'What are the causes of your current emotions?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: factors.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildFactorOption(
                              factors[index]['text'],
                              factors[index]['selected'],
                              (value) {
                                setState(() {
                                  factors[index]['selected'] = value;
                                });
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Something Else?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Let\'s identify factors affecting your mood',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          height: 104, // updated from 80
                          width: 364, // updated from 292
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: 4,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Quicksand',
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Input text',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'General Sans',
                              ),
                              contentPadding: EdgeInsets.all(14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12,
                ),
                child: _buildCompleteButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactorOption(
    String text,
    bool isSelected,
    Function(bool) onChanged,
  ) {
    return Container(
      height: 45,
      width: 364,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8F7EFF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBBB3FF), // Changed to #BBB3FF
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8F7EFF).withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : const Color(0xFF8F7EFF),
                  border: Border.all(
                    color: const Color(
                      0xFF8F7EFF,
                    ), // Always purple border for circle
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? const Icon(
                          Icons.check,
                          size: 11,
                          color: Color(0xFF8F7EFF),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                    fontFamily: 'General Sans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return ElevatedButton(
      onPressed: () {
        final selectedFactors =
            factors
                .where((factor) => factor['selected'])
                .map((factor) => factor['text'])
                .toList();

        final customFactor = _textController.text.trim();
        if (customFactor.isNotEmpty) {
          selectedFactors.add(customFactor);
        }

        // Navigate to the completion screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MoodCheckinCompleteScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8F7EFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Complete Mood Checkin',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'General Sans',
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.check, size: 18),
        ],
      ),
    );
  }
}
