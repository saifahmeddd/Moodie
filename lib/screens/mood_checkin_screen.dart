import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodie_v2/screens/home_page.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MoodCheckinApp());
}

class MoodCheckinApp extends StatelessWidget {
  const MoodCheckinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'quicksand',
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'quicksand', letterSpacing: -1.5),
          labelMedium: TextStyle(fontFamily: 'quicksand', letterSpacing: -1.5),
        ),
      ),
      home: const MoodCheckinScreen(),
    );
  }
}

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  _MoodCheckinScreenState createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  final List<Map<String, String>> _moodOptions = [
    {
      'label': 'Light & Clear',
      'description': 'Feeling okay, balanced, calm',
      'icon': 'assets/icons/cloud-sun-light.svg',
    },
    {
      'label': 'Chaotic & Scattered',
      'description': 'Distracted, stressed, messy mind',
      'icon': 'assets/icons/head-circuit-light.svg',
    },
    {
      'label': 'Grounded & Growing',
      'description': 'Hopeful, improving, intentional',
      'icon': 'assets/icons/leaf-light.svg',
    },
    {
      'label': 'Heavy & Drowning',
      'description': 'Overwhelmed, stuck, emotional',
      'icon': 'assets/icons/cloud-rain-light.svg',
    },
    {
      'label': 'Cloudy & Low',
      'description': 'Unmotivated, sad, flat',
      'icon': 'assets/icons/Vector.svg',
    },
    {
      'label': 'Wired & On edge',
      'description': 'Anxious, overthinking, restless',
      'icon': 'assets/icons/fire-light.svg',
    },
  ];

  final List<int> _selectedMoods = [];

  void _toggleMood(int index) {
    setState(() {
      if (_selectedMoods.contains(index)) {
        _selectedMoods.remove(index);
      } else {
        _selectedMoods.add(index);
      }
    });
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ), // Navigate to the actual HomePage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const CustomBackButton(iconColor: Colors.black87, iconSize: 24),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "What's the vibe today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'quicksand',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose one or more options that resonate with you',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'General Sans',
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _moodOptions.length,
                itemBuilder: (context, index) {
                  final mood = _moodOptions[index];
                  final isSelected = _selectedMoods.contains(index);
                  return _buildMoodOptionCard(mood, isSelected, index);
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedMoods.isNotEmpty) {
                    print('Selected Moods: $_selectedMoods');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mood checked in successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    _navigateToHomePage(); // Navigate to HomePage
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select at least one mood.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(125, 125, 222, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: const Text(
                  'Check In',
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    letterSpacing: 0,
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOptionCard(
    Map<String, String> mood,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _toggleMood(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ), // Only vertical padding
        height: 64, // Fixed height
        width: double.infinity, // Fill available width
        decoration: BoxDecoration(
          gradient: null,
          color:
              isSelected
                  ? const Color(0xFFE5E5F8)
                  : Colors.white, // Selected: light purple, Unselected: white
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected
                    ? const Color.fromARGB(255, 96, 96, 211)
                    : const Color(0xFFBBB3FF),
            width: isSelected ? 2 : 2,
          ),
          boxShadow: [
            if (!isSelected)
              const BoxShadow(
                color: Color.fromRGBO(
                  187,
                  179,
                  255,
                  0.4,
                ), // BBB3FF at 12% opacity for subtle effect
                offset: Offset(0, 0),
                blurRadius: 0,
                spreadRadius: 3,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: <Widget>[
            SvgPicture.asset(
              mood['icon'] ?? 'assets/icons/placeholder.svg',
              width: 20, // Icon width 20
              height: 20, // Icon height 20
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center text vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mood['label'] ?? 'Label',
                    style: TextStyle(
                      fontFamily: 'General Sans',
                      letterSpacing: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black87,
                    ),
                  ),
                  Text(
                    mood['description'] ?? 'Description',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'General Sans',
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ), // Subtitle font size 10
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
