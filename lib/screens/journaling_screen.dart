import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'journal_entry_screen.dart';
import '../widgets/custom_back_button.dart';
import 'journal_scratch_entry_screen.dart';
import 'saved_prompts_screen.dart';

class JournalingScreen extends StatefulWidget {
  JournalingScreen({Key? key}) : super(key: key);

  @override
  State<JournalingScreen> createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> prompts = [
    {
      'title': 'Values Check-in',
      'desc': 'What values did I uphold today, and when did I stray?',
    },
    {
      'title': 'Learning Corner',
      'desc': 'What did I learn today about myself, others, or the world?',
    },
    {
      'title': 'Anxiety Dialogue',
      'desc': 'What could I accomplish if I weren\'t so anxious all the time?',
    },
    {
      'title': 'Success Stories',
      'desc': 'List three small achievements I\'m proud of today',
    },
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  CustomBackButton(iconColor: Colors.black87, iconSize: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reflect & Renew',
                          style: TextStyle(
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Colors.black,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JournalScratchEntryScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Write from scratch'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7D7DDE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'GeneralSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SavedPromptsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.bookmark_border, size: 18),
                            label: const Text('View Saved Prompts'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                color: Color(0xFFB9B6F3),
                                width: 1.2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'GeneralSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Prompts',
                          style: TextStyle(
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...prompts.map(
                          (prompt) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => JournalEntryScreen(
                                            prompt:
                                                prompt['title']!, // Only the title
                                            tips: [
                                              'Write without judging or editing your thoughts',
                                              'Focus on feelings, not just events.',
                                              'Start each entry by writing one word that describes today',
                                            ],
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFB9B6F3),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              prompt['title']!,
                                              style: const TextStyle(
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              prompt['desc']!,
                                              style: const TextStyle(
                                                fontFamily: 'General Sans',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black87,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 22,
                                        color: Color(0xFF8C88F8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                    ? 'assets/icons/nav-icons/smiley-fill.svg'
                    : 'assets/icons/nav-icons/smiley.svg',
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
                    ? 'assets/icons/nav-icons/heartbeat-fill.svg'
                    : 'assets/icons/nav-icons/heartbeat.svg',
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
