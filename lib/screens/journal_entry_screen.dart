import 'package:flutter/material.dart';
import '../widgets/custom_back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalEntryScreen extends StatefulWidget {
  final String prompt;
  final List<String> tips;

  const JournalEntryScreen({Key? key, required this.prompt, required this.tips})
    : super(key: key);

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: CustomBackButton(iconColor: Colors.black87, iconSize: 28),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Text(
                widget.prompt,
                style: const TextStyle(
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Changed from 24 to 18
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontFamily: 'quicksand',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Start writing your thoughts here...\n(You can always edit or add more later)',
                    hintStyle: TextStyle(
                      fontFamily: 'quicksand',
                      fontSize: 15,
                      color: Colors.black38,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You must be logged in to save entries.',
                          ),
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
                            'prompt': widget.prompt,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Entry saved!')),
                      );
                      _controller.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to save entry: \\${e.toString()}',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Save Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7D7DDE),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
