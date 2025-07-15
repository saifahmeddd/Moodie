import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'emotion_tags.dart'; // Import the correct EmotionTagsScreen
import '../widgets/custom_back_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  late GifController _greatMoodController;
  late GifController _goodMoodController;
  late GifController _soSoMoodController;
  late GifController _badMoodController;
  late GifController _veryBadMoodController;

  int _selectedMood = 2; // Default to 'Good'

  @override
  void initState() {
    super.initState();
    _greatMoodController = GifController();
    _goodMoodController = GifController();
    _soSoMoodController = GifController();
    _badMoodController = GifController();
    _veryBadMoodController = GifController();
  }

  @override
  void dispose() {
    _greatMoodController.dispose();
    _goodMoodController.dispose();
    _soSoMoodController.dispose();
    _badMoodController.dispose();
    _veryBadMoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match navbar color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              _buildAppBar(),
              const SizedBox(height: 40), // More space below app bar
              _buildSelectedMoodGif(),
              const SizedBox(height: 32), // More space below GIF
              _buildMoodSelection(),
              const Spacer(), // Pushes the button to the bottom
              _buildContinueButton(),
              const SizedBox(height: 20), // Optional: keep for bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomBackButton(
            iconColor: Colors.grey[800],
            iconSize: 24,
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushReplacementNamed('/home');
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'How would you describe your mood today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontFamily: 'quicksand',
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMoodGif() {
    String gifPath = '';
    switch (_selectedMood) {
      case 1:
        gifPath = 'assets/gifs/great.gif';
        break;
      case 2:
        gifPath = 'assets/gifs/good.gif';
        break;
      case 3:
        gifPath = 'assets/gifs/neutral-face.gif';
        break;
      case 4:
        gifPath = 'assets/gifs/bad.gif';
        break;
      case 5:
        gifPath = 'assets/gifs/pouting-face.gif';
        break;
    }
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GifView.asset(gifPath, height: 200, width: 200, loop: true),
      ),
    );
  }

  Widget _buildMoodSelection() {
    // Mood data with SVG asset paths
    final moods = [
      {
        'mood': 1,
        'title': 'Great',
        'svg': 'assets/emojis/mood-scale/great.svg',
      },
      {'mood': 2, 'title': 'Good', 'svg': 'assets/emojis/mood-scale/good.svg'},
      {
        'mood': 3,
        'title': 'So-so',
        'svg': 'assets/emojis/mood-scale/so-so.svg',
      },
      {'mood': 4, 'title': 'Bad', 'svg': 'assets/emojis/mood-scale/bad.svg'},
      {
        'mood': 5,
        'title': 'Very Bad',
        'svg': 'assets/emojis/mood-scale/very-bad.svg',
      },
    ];

    final selectedMood = moods.firstWhere((m) => m['mood'] == _selectedMood);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show selected mood text above the bar
        Text(
          selectedMood['title'] as String,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'quicksand',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150, // More height for better balance and padding
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Gradient bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 24, // Bar is lower, more space below emojis
                child: Container(
                  height: 14, // Slightly thicker bar
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                  ), // Responsive horizontal padding
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4CAF50), // Green
                        Color(0xFFFFEB3B), // Yellow
                        Color(0xFFFF9800), // Orange
                        Color(0xFFF44336), // Red
                      ],
                      stops: [0.0, 0.33, 0.66, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              // Emojis/icons above the bar
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.09,
                  ), // Responsive, not too close to edge
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:
                        moods.map((moodData) {
                          final isSelected = _selectedMood == moodData['mood'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMood = moodData['mood'] as int;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.only(
                                bottom: isSelected ? 64 : 72,
                              ), // 40px above bar for clear separation
                              padding: EdgeInsets.all(isSelected ? 7 : 0),
                              decoration:
                                  isSelected
                                      ? BoxDecoration(
                                        color: const Color(0xFFEDE7F6),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purple.withOpacity(
                                              0.15,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      )
                                      : null,
                              child: SvgPicture.asset(
                                moodData['svg'] as String,
                                height: 44,
                                width: 44,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedMood != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmotionTagsScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select your mood.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7D7DDE),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(
            fontFamilyFallback: ['General Sans'],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: const Text('Select Mood'),
      ),
    );
  }
}
