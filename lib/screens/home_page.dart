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
    const MoodTrackerScreen(),
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
    if (index == 2) {
      Navigator.pushNamed(context, '/exercises');
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 0
                    ? 'assets/icons/nav-icons/house-fill.svg'
                    : 'assets/icons/nav-icons/house.svg',
                height: 28,
                width: 28,
                color:
                    _selectedIndex == 0 ? const Color(0xFF7D7DDE) : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 1
                    ? 'assets/icons/nav-icons/heartbeat-fill.svg'
                    : 'assets/icons/nav-icons/heartbeat.svg',
                height: 28,
                width: 28,
                color:
                    _selectedIndex == 1 ? const Color(0xFF7D7DDE) : Colors.grey,
              ),
              label: 'Tracker',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 2
                    ? 'assets/icons/nav-icons/smiley-fill.svg'
                    : 'assets/icons/nav-icons/smiley.svg',
                height: 28,
                width: 28,
                color:
                    _selectedIndex == 2 ? const Color(0xFF7D7DDE) : Colors.grey,
              ),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 3
                    ? 'assets/icons/nav-icons/user-circle-fill.svg'
                    : 'assets/icons/nav-icons/user-circle.svg',
                height: 28,
                width: 28,
                color:
                    _selectedIndex == 3 ? const Color(0xFF7D7DDE) : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF7D7DDE),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
        ),
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
    return _AnimatedTile(
      onTap: onTap,
      child: SizedBox(
        width: 364,
        height: 236,
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
                                        label == 'Mood Tracker'
                                            ? Colors.black
                                            : isJournalingTile
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
                                      label == 'Mood Tracker'
                                          ? Colors.black
                                          : isJournalingTile
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
    return ListView(
      physics: const ReducedBouncingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 52,
            left: 20,
            right: 20,
            bottom: 80,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF535394),
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
                  onTap: () => Navigator.pushNamed(context, '/journaling'),
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
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReducedBouncingScrollPhysics extends BouncingScrollPhysics {
  const ReducedBouncingScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  ReducedBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ReducedBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // Reduce the overscroll by a factor (e.g., 0.4)
    final double defaultResult = super.applyBoundaryConditions(position, value);
    return defaultResult * 0.4;
  }
}

class rgba {
  const rgba();
}

class _AnimatedTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _AnimatedTile({required this.child, required this.onTap});

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
