import 'package:flutter/material.dart';
import 'factors.dart'; // Ensure this import points to your actual factors.dart location

class EmotionTagsScreen extends StatefulWidget {
  const EmotionTagsScreen({super.key});

  @override
  State<EmotionTagsScreen> createState() => _EmotionTagsScreenState();
}

class _EmotionTagsScreenState extends State<EmotionTagsScreen> {
  final Map<String, List<Map<String, dynamic>>> emotionCategories = {
    'Stress Level': [
      {'emoji': '😌', 'label': 'Imequiet', 'selected': false},
      {'emoji': '😨', 'label': 'Nervous', 'selected': false},
      {'emoji': '😰', 'label': 'Stressed', 'selected': false},
      {'emoji': '😟', 'label': 'Anxious', 'selected': false},
      {'emoji': '😫', 'label': 'Burnt out', 'selected': false},
    ],
    'Energy Level': [
      {'emoji': '😄', 'label': 'Energetic', 'selected': false},
      {'emoji': '🤩', 'label': 'Excited', 'selected': false},
      {'emoji': '🤪', 'label': 'Inspired', 'selected': false},
      {'emoji': '🧐', 'label': 'Focused', 'selected': false},
      {'emoji': '😪', 'label': 'Lazy', 'selected': false},
    ],
    'Lowness & Annoyance': [
      {'emoji': '😔', 'label': 'Sad', 'selected': false},
      {'emoji': '😫', 'label': 'Tired', 'selected': false},
      {'emoji': '😠', 'label': 'Annoyed', 'selected': false},
      {'emoji': '😤', 'label': 'Frustrated', 'selected': false},
      {'emoji': '😡', 'label': 'Angry', 'selected': false},
    ],
    'Calm & Positive': [
      {'emoji': '😊', 'label': 'Grateful', 'selected': false},
      {'emoji': '😁', 'label': 'Happy', 'selected': false},
      {'emoji': '😃', 'label': 'Optimistic', 'selected': false},
      {'emoji': '😌', 'label': 'Relaxed', 'selected': false},
      {'emoji': '😎', 'label': 'Confident', 'selected': false},
    ],
    'Vibes': [
      {'emoji': '🤣', 'label': 'Hilarious', 'selected': false},
      {'emoji': '😏', 'label': 'Naughty', 'selected': false},
      {'emoji': '🥳', 'label': 'Party', 'selected': false},
      {'emoji': '🤔', 'label': 'Thoughtful', 'selected': false},
      {'emoji': '😐', 'label': 'Bored', 'selected': false},
    ],
    'Others': [
      {'emoji': '😢', 'label': 'Overwhelmed', 'selected': false},
      {'emoji': '🥰', 'label': 'Loved', 'selected': false},
      {'emoji': '😐', 'label': 'Numb', 'selected': false},
      {'emoji': '😊', 'label': 'Low', 'selected': false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...emotionCategories.entries.map((entry) {
                          return _buildCategorySection(entry.key, entry.value);
                        }).toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Emotion Tags',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<Map<String, dynamic>> emotions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              emotions.asMap().entries.map((entry) {
                final emotion = entry.value;
                final index = entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      emotion['selected'] = !emotion['selected'];
                    });
                  },
                  child: _buildEmotionTag(
                    emoji: emotion['emoji'],
                    label: emotion['label'],
                    isSelected: emotion['selected'],
                    color: _getTagColor(title, index),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  Color _getTagColor(String category, int index) {
    if (category == 'Stress Level' && index == 1)
      return const Color(0xFF8F7EFF);
    if (category == 'Lowness & Annoyance' && index == 0)
      return const Color(0xFF8F7EFF);
    if (category == 'Calm & Positive' && (index == 0 || index == 1))
      return const Color(0xFF8F7EFF);
    if (category == 'Vibes' && index == 2) return const Color(0xFF8F7EFF);
    if (category == 'Others' && index == 0) return const Color(0xFF8F7EFF);
    return Colors.grey[100]!;
  }

  Widget _buildEmotionTag({
    required String emoji,
    required String label,
    required bool isSelected,
    required Color color,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 4,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8F7EFF) : color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24, fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isSelected || color != Colors.grey[100]!
                      ? Colors.white
                      : Colors.black87,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          final selectedEmotions = <String>[];
          emotionCategories.forEach((category, emotions) {
            emotions.forEach((emotion) {
              if (emotion['selected']) {
                selectedEmotions.add(emotion['label']);
              }
            });
          });

          print('Selected emotions: $selectedEmotions');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FactorsScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8F7EFF),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Next Step',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
