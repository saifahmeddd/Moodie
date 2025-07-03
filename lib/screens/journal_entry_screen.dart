import 'package:flutter/material.dart';

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
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.black87,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
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
                  fontSize: 24,
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
                  onPressed: () {
                    // Placeholder for save action
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entry saved!')),
                    );
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Save Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C88F8),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
