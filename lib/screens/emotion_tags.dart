import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_back_button.dart';
import 'factors.dart';

class EmotionTagsScreen extends StatefulWidget {
  const EmotionTagsScreen({super.key});

  @override
  State<EmotionTagsScreen> createState() => _EmotionTagsScreenState();
}

class _EmotionTagsScreenState extends State<EmotionTagsScreen> {
  // Each emoji is a map with asset, label, and selected state
  final Map<String, List<Map<String, dynamic>>> emotionCategories = {
    'Stress Level': [
      {
        'key': 'insecure',
        'emojiAsset': 'assets/emojis/stressed/Face in clouds.svg',
        'label': 'Insecure',
        'selected': false,
      },
      {
        'key': 'nervous',
        'emojiAsset': 'assets/emojis/stressed/Anxious face with sweat.svg',
        'label': 'Nervous',
        'selected': false,
      },
      {
        'key': 'stressed',
        'emojiAsset': 'assets/emojis/others/stressed.svg',
        'label': 'Stressed',
        'selected': false,
      },
      {
        'key': 'anxious',
        'emojiAsset': 'assets/emojis/stressed/Sad but relieved face.svg',
        'label': 'Anxious',
        'selected': false,
      },
      {
        'key': 'burnt_out',
        'emojiAsset': 'assets/emojis/stressed/Knocked-out face.svg',
        'label': 'Burnt out',
        'selected': false,
      },
    ],
    'Energy Level': [
      {
        'key': 'energetic',
        'emojiAsset': 'assets/emojis/energy/Beaming face with smiling eyes.svg',
        'label': 'Energetic',
        'selected': false,
      },
      {
        'key': 'excited',
        'emojiAsset': 'assets/emojis/energy/Grinning face with big eyes.svg',
        'label': 'Excited',
        'selected': false,
      },
      {
        'key': 'inspired',
        'emojiAsset': 'assets/emojis/energy/Star-struck.svg',
        'label': 'Inspired',
        'selected': false,
      },
      {
        'key': 'focused',
        'emojiAsset': 'assets/emojis/energy/Nerd face.svg',
        'label': 'Focused',
        'selected': false,
      },
      {
        'key': 'lazy',
        'emojiAsset': 'assets/emojis/energy/Sleepy face.svg',
        'label': 'Lazy',
        'selected': false,
      },
    ],
    'Lowness & Annoyance': [
      {
        'key': 'sad',
        'emojiAsset': 'assets/emojis/annoyance/Pensive face.svg',
        'label': 'Sad',
        'selected': false,
      },
      {
        'key': 'tired',
        'emojiAsset': 'assets/emojis/annoyance/Tired face.svg',
        'label': 'Tired',
        'selected': false,
      },
      {
        'key': 'annoyed',
        'emojiAsset': 'assets/emojis/annoyance/Unamused face.svg',
        'label': 'Annoyed',
        'selected': false,
      },
      {
        'key': 'frustrated',
        'emojiAsset': 'assets/emojis/annoyance/Confounded face.svg',
        'label': 'Frustrated',
        'selected': false,
      },
      {
        'key': 'angry',
        'emojiAsset': 'assets/emojis/annoyance/Pouting face.svg',
        'label': 'Angry',
        'selected': false,
      },
    ],
    'Calm & Positive': [
      {
        'key': 'grateful',
        'emojiAsset': '😊', // Unicode emoji
        'label': 'Grateful',
        'selected': false,
      },
      {
        'key': 'happy',
        'emojiAsset': '😄', // Unicode emoji
        'label': 'Happy',
        'selected': false,
      },
      {
        'key': 'optimistic',
        'emojiAsset': 'assets/emojis/positive/Face exhaling.svg',
        'label': 'Optimistic',
        'selected': false,
      },
      {
        'key': 'relaxed',
        'emojiAsset': 'assets/emojis/positive/Winking face.svg',
        'label': 'Relaxed',
        'selected': false,
      },
      {
        'key': 'confident',
        'emojiAsset': 'assets/emojis/positive/Smiling face with sunglasses.svg',
        'label': 'Confident',
        'selected': false,
      },
    ],
    'Vibes': [
      {
        'key': 'hilarious',
        'emojiAsset': '😂', // Unicode emoji
        'label': 'Hilarious',
        'selected': false,
      },
      {
        'key': 'naughty',
        'emojiAsset': 'assets/emojis/vibes/Winking face with tongue.svg',
        'label': 'Naughty',
        'selected': false,
      },
      {
        'key': 'party',
        'emojiAsset': 'assets/emojis/vibes/Partying face.svg',
        'label': 'Party',
        'selected': false,
      },
      {
        'key': 'thoughtful',
        'emojiAsset': 'assets/emojis/vibes/Thinking face.svg',
        'label': 'Thoughtful',
        'selected': false,
      },
      {
        'key': 'bored',
        'emojiAsset': 'assets/emojis/vibes/Face with rolling eyes.svg',
        'label': 'Bored',
        'selected': false,
      },
    ],
    'Others': [
      {
        'key': 'overwhelmed',
        'emojiAsset': 'assets/emojis/others/stressed.svg',
        'label': 'Overwhelmed',
        'selected': false,
      },
      {
        'key': 'loved',
        'emojiAsset': 'assets/emojis/others/loved.svg',
        'label': 'Loved',
        'selected': false,
      },
      {
        'key': 'numb',
        'emojiAsset': 'assets/emojis/others/Numb.svg',
        'label': 'Numb',
        'selected': false,
      },
      {
        'key': 'low',
        'emojiAsset': 'assets/emojis/others/Low.svg',
        'label': 'Low',
        'selected': false,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 8,
                right: 8,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(iconColor: Colors.black87, iconSize: 24),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Emotion Tags',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...emotionCategories.entries.map((entry) {
                      return _buildCategory(entry.key, entry.value);
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String title, List<Map<String, dynamic>> emotions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Quicksand',
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              emotions.map((emotion) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      emotion['selected'] = !(emotion['selected'] as bool);
                    });
                  },
                  child: _buildEmotionTag(
                    emojiAsset: emotion['emojiAsset'],
                    label: emotion['label'],
                    isSelected: emotion['selected'],
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 8),
        const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _buildEmotionTag({
    required String emojiAsset,
    required String label,
    required bool isSelected,
  }) {
    bool isUnicodeEmoji =
        !emojiAsset.endsWith('.svg') && !emojiAsset.endsWith('.png');
    return Container(
      width: 80,
      height: 98,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8F7EFF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFF8F7EFF) : const Color(0xFFE6E6FA),
          width: 2,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF8F7EFF).withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isUnicodeEmoji
              ? Text(emojiAsset, style: const TextStyle(fontSize: 36))
              : SvgPicture.asset(
                emojiAsset,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                placeholderBuilder:
                    (context) =>
                        const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'General Sans',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: () {
            final selectedEmotions = <String>[];
            emotionCategories.forEach((category, emotions) {
              for (var emotion in emotions) {
                if (emotion['selected'] == true) {
                  selectedEmotions.add(emotion['label']);
                }
              }
            });
            // print('Selected emotions: $selectedEmotions');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FactorsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D7DDE),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'General Sans',
              letterSpacing: -0.5,
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next Step'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
