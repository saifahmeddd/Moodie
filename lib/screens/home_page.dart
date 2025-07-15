import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart'; // Import the ProfileScreen
import 'mood_tracker.dart'; // Import the MoodTracker screen
import 'breathing_exercises_screen.dart'; // Import the BreathingExercisesScreen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenContent(),
    const MoodTrackerApp(),
    const Center(
      child: Text(
        'Exercises',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    ),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5AE0),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in.");
      }

      String uid = currentUser.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? 'User';
        });
      } else {
        setState(() {
          _userName = 'User';
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
      setState(() {
        _userName = 'User';
      });
    }
  }

  Widget buildTile({
    required String text,
    required String label,
    required String svgPath,
    required VoidCallback onTap,
    required Color color,
    required TextStyle textStyle,
    BoxBorder? border,
  }) {
    final bool isBreathingTile =
        label == 'Exercises' && svgPath == 'assets/images/meditation.svg';
    final bool isJournalingTile =
        label == 'Journaling' && svgPath == 'assets/images/writing.svg';
    final bool isPromptsTile =
        label == 'Prompts' && svgPath == 'assets/images/prompt.svg';
    return SizedBox(
      width: 364,
      height: 236,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
            border: border,
          ),
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(bottom: 20),
          child:
              isBreathingTile
                  ? Row(
                    children: [
                      SvgPicture.asset(svgPath, height: 130, width: 130),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(text, style: textStyle),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : isPromptsTile
                  ? Row(
                    children: [
                      SvgPicture.asset(svgPath, height: 130, width: 130),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(text, style: textStyle),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(text, style: textStyle),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isJournalingTile
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 14,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color:
                                      isJournalingTile
                                          ? Colors.black
                                          : Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        svgPath,
                        height: isJournalingTile ? 150 : 130,
                        width: isJournalingTile ? 150 : 130,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 80,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF6A5AE0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Welcome, ${_userName ?? 'User'}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '"Your mind matters. Every day, in every way."',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -60),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended for today',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTile(
                    text:
                        "You don't have to hold it all alone. Let's talk or write it out",
                    label: 'Chat with Nova',
                    svgPath: 'assets/images/robot.svg',
                    onTap: () => Navigator.pushNamed(context, '/chatbot'),
                    color: const Color(0xFF2A2A4A),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.2,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Take a deep breath',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTile(
                    text:
                        "Let's calm your system - start with a few mindful breaths",
                    label: 'Exercises',
                    svgPath: 'assets/images/meditation.svg',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BreathingExercisesScreen(),
                          ),
                        ),
                    color: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: Colors.black,
                    ),
                    border: Border.all(
                      color: Color(0xFFD1C4E9), // light purple
                      width: 2,
                    ),
                  ),
                  const Text(
                    'Explore yourself',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTile(
                    text:
                        "When thoughts feel tangled, writing them out can bring clarity.",
                    label: 'Journaling',
                    svgPath: 'assets/images/writing.svg',
                    onTap: () => Navigator.pushNamed(context, '/journaling'),
                    color: const Color.fromRGBO(229, 229, 248, 1),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Daily Prompts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTile(
                    text:
                        "Get inspired with a new reflection or writing prompt today.",
                    label: 'Prompts',
                    svgPath: 'assets/images/prompt.svg',
                    onTap: () => Navigator.pushNamed(context, '/prompts'),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: Colors.black,
                    ),
                    border: Border.all(
                      color: Color(0xFFD1C4E9), // light purple
                      width: 2,
                    ),
                  ),
                  const Text(
                    'Mood Check-In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildTile(
                    text:
                        "Check in with how you feel. Awareness is the first step.",
                    label: 'Mood Tracker',
                    svgPath: 'assets/images/mood.svg',
                    onTap: () => Navigator.pushNamed(context, '/mood'),
                    color: const Color.fromRGBO(229, 229, 248, 1),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class rgba {
  const rgba();
}
