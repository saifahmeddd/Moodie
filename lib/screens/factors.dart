import 'package:flutter/material.dart';
import '../widgets/custom_back_button.dart';

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
                        const Text(
                          'What are the causes of your current emotions?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Quicksand',
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Let\'s identify factors affecting your mood',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
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
                                fontFamily: 'Quicksand',
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
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8F7EFF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF8F7EFF) : const Color(0xFFD7D2FF),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : const Color(0xFF8F7EFF),
                  border: Border.all(
                    color: isSelected ? Colors.white : const Color(0xFF8F7EFF),
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF8F7EFF),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                    fontFamily: 'Quicksand',
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

        print('Selected factors: $selectedFactors');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8F7EFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Complete Mood Checkin',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Quicksand',
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.check, size: 18),
        ],
      ),
    );
  }
}
