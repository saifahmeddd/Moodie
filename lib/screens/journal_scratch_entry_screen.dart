import 'package:flutter/material.dart';
import '../widgets/custom_back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalScratchEntryScreen extends StatefulWidget {
  const JournalScratchEntryScreen({Key? key}) : super(key: key);

  @override
  State<JournalScratchEntryScreen> createState() =>
      _JournalScratchEntryScreenState();
}

class _JournalScratchEntryScreenState extends State<JournalScratchEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _saved = false;

  final List<String> tips = [
    'Write without judging or editing your thoughts',
    'Focus on feelings, not just events.',
    'Start each entry by writing one word that describes today',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF8F7FAFF),
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
                  CustomBackButton(iconColor: Colors.black87, iconSize: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 69, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What’s on your mind today?",
                        style: TextStyle(
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...tips.map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            tip,
                            style: const TextStyle(
                              fontFamily: 'GeneralSans',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _controller,
                        minLines: 12,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Start writing your thoughts here... ',
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontFamily: 'GeneralSans',
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You must be logged in to save entries.'),
                  ),
                );
                return;
              }
              final entryText = _controller.text.trim();
              if (entryText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entry cannot be empty.')),
                );
                return;
              }
              try {
                await FirebaseFirestore.instance
                    .collection('journal_entries')
                    .add({
                      'userId': user.uid,
                      'entry': entryText,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                setState(() {
                  _saved = true;
                });
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Entry saved!')));
                _controller.clear();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save entry: \\${e.toString()}'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.bookmark_border),
            label: const Text('Save Entry', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7D7DDE),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: const TextStyle(
                fontFamily: 'GeneralSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
