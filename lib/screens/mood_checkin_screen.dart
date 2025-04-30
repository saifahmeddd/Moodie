import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodie_v2/screens/home_page.dart'; // Import the actual HomePage from home_page.dart

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
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Inter'),
          labelMedium: TextStyle(fontFamily: 'Inter'),
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
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "What's the vibe today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose one or more options that resonate with you',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 190, 137, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: const Text(
                  'Check In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 229, 207, 255),
                      Color.fromARGB(255, 229, 207, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected
                    ? const Color.fromARGB(255, 112, 0, 150)
                    : const Color.fromARGB(255, 195, 165, 210),
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              mood['icon'] ?? 'assets/icons/placeholder.svg',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    mood['label'] ?? 'Label',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black87,
                    ),
                  ),
                  Text(
                    mood['description'] ?? 'Description',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
