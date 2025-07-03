import 'package:flutter/material.dart';
import 'journal_entry_screen.dart';

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

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/mood-tracker');
        break;
      case 2:
        // Placeholder for Exercises
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Exercises coming soon!')));
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.black87,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Write from scratch'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8C88F8),
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
                            onPressed: () {},
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
                          'Prompts you can try..',
                          style: TextStyle(
                            fontFamily: 'GeneralSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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
                                                prompt['title']! +
                                                '\n' +
                                                prompt['desc']!,
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
                                                fontSize: 16,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              prompt['desc']!,
                                              style: const TextStyle(
                                                fontFamily: 'quicksand',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black87,
                                                letterSpacing: -0.5,
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8C88F8),
        unselectedItemColor: Colors.grey[500],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
