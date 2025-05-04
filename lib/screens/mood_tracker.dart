import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'emotion_tags.dart'; // Import the correct EmotionTagsScreen

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Nunito'),
          bodyMedium: TextStyle(fontFamily: 'Nunito'),
          displayLarge: TextStyle(fontFamily: 'Nunito'),
          displayMedium: TextStyle(fontFamily: 'Nunito'),
          displaySmall: TextStyle(fontFamily: 'Nunito'),
          headlineLarge: TextStyle(fontFamily: 'Nunito'),
          headlineMedium: TextStyle(fontFamily: 'Nunito'),
          headlineSmall: TextStyle(fontFamily: 'Nunito'),
          labelLarge: TextStyle(fontFamily: 'Nunito'),
          labelMedium: TextStyle(fontFamily: 'Nunito'),
          labelSmall: TextStyle(fontFamily: 'Nunito'),
        ),
      ),
      home: const MoodTrackerScreen(),
    );
  }
}

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

  int _selectedMood = 0;

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
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              _buildAppBar(),
              const SizedBox(height: 20),
              if (_selectedMood != 0)
                Expanded(child: _buildSelectedMoodGif(), flex: 2),
              const SizedBox(height: 10),
              Expanded(flex: 3, child: _buildMoodSelection()),
              const SizedBox(height: 20),
              _buildContinueButton(),
              const SizedBox(height: 20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              'How would you describe your mood today?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontFamily: 'quicksand',
              ),
              textAlign: TextAlign.center,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildMoodColumn(
            mood: 1,
            title: 'Great',
            gifController: _greatMoodController,
            gifPath: 'assets/gifs/great.gif',
          ),
          const SizedBox(width: 10),
          _buildMoodColumn(
            mood: 2,
            title: 'Good',
            gifController: _goodMoodController,
            gifPath: 'assets/gifs/good.gif',
          ),
          const SizedBox(width: 10),
          _buildMoodColumn(
            mood: 3,
            title: 'So-so',
            gifController: _soSoMoodController,
            gifPath: 'assets/gifs/neutral-face.gif',
          ),
          const SizedBox(width: 10),
          _buildMoodColumn(
            mood: 4,
            title: 'Bad',
            gifController: _badMoodController,
            gifPath: 'assets/gifs/bad.gif',
          ),
          const SizedBox(width: 10),
          _buildMoodColumn(
            mood: 5,
            title: 'Very Bad',
            gifController: _veryBadMoodController,
            gifPath: 'assets/gifs/pouting-face.gif',
          ),
        ],
      ),
    );
  }

  Widget _buildMoodColumn({
    required int mood,
    required String title,
    required GifController gifController,
    required String gifPath,
  }) {
    final isSelected = _selectedMood == mood;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? const Color(0xFFEDE7F6) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: GifView.asset(
                  gifPath,
                  controller: gifController,
                  height: 60,
                  width: 60,
                  loop: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF5E35B1) : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            _buildMoodBar(mood: mood),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodBar({required int mood}) {
    Color startColor;
    Color endColor;

    switch (mood) {
      case 1:
        startColor = const Color(0xFF4CAF50);
        endColor = const Color(0xFF81C784);
        break;
      case 2:
        startColor = const Color(0xFF66BB6A);
        endColor = const Color(0xFFA5D6A7);
        break;
      case 3:
        startColor = const Color(0xFFFFC107);
        endColor = const Color(0xFFFFD54F);
        break;
      case 4:
        startColor = const Color(0xFFF44336);
        endColor = const Color(0xFFE57373);
        break;
      case 5:
        startColor = const Color(0xFFD32F2F);
        endColor = const Color(0xFFF44336);
        break;
      default:
        startColor = Colors.grey[300]!;
        endColor = Colors.grey[300]!;
    }

    return Container(
      height: 6,
      width: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
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
          backgroundColor: const Color.fromARGB(255, 135, 88, 228),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        child: const Text('Continue'),
      ),
    );
  }
}
