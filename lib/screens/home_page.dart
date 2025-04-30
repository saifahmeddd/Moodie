import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenContent(),
    Center(
      child: Text(
        'Tracker',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Exercises',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Changed AppBar background to white
        elevation: 0,
        title: null,
      ),
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 198,
        width: 364,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 12, // Increased font size
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.indigo,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SvgPicture.asset(svgPath, height: 150, width: 150),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✨ Simple Good Morning Text ✨
          Text(
            'Good Morning, ${_userName ?? 'User'}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            '"Your mind matters. Every day, in every way."',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          const Text(
            'Recommended for today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildTile(
            text:
                "You don't have to hold it all alone. Let's talk or write it out",
            label: 'Exercises',
            svgPath: 'assets/images/robot.svg',
            onTap: () => Navigator.pushNamed(context, '/chatbot'),
          ),
          const Text(
            'Take a deep breath',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildTile(
            text: "Let's calm your system - start with a few mindful breaths",
            label: 'Exercises',
            svgPath: 'assets/images/meditation.svg',
            onTap: () => Navigator.pushNamed(context, '/breathing'),
          ),
          const Text(
            'Explore yourself',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildTile(
            text:
                "When thoughts feel tangled, writing them out can bring clarity.",
            label: 'Journaling',
            svgPath: 'assets/images/writing.svg',
            onTap: () => Navigator.pushNamed(context, '/journaling'),
          ),
          const Text(
            'Daily Prompts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildTile(
            text: "Get inspired with a new reflection or writing prompt today.",
            label: 'Prompts',
            svgPath: 'assets/images/prompt.svg',
            onTap: () => Navigator.pushNamed(context, '/prompts'),
          ),
          const Text(
            'Mood Check-In',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          buildTile(
            text: "Check in with how you feel. Awareness is the first step.",
            label: 'Mood Tracker',
            svgPath: 'assets/images/mood.svg',
            onTap: () => Navigator.pushNamed(context, '/mood'),
          ),
        ],
      ),
    );
  }
}
