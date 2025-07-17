import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_back_button.dart';

class SavedPromptsScreen extends StatelessWidget {
  const SavedPromptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xF8F7FBF9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: CustomBackButton(iconColor: Colors.black87, iconSize: 28),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Revisit saved prompts',
                style: TextStyle(
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  user == null
                      ? const Center(child: Text('You must be logged in.'))
                      : StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('journal_entries')
                                .where('userId', isEqualTo: user.uid)
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No saved prompts yet.'),
                            );
                          }
                          final entries = snapshot.data!.docs;
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: entries.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              final data = entry.data() as Map<String, dynamic>;
                              final prompt = data['prompt'] ?? 'No prompt';
                              final promptTitle = prompt.split('\n').first;
                              final timestamp = data['timestamp'] as Timestamp?;
                              String dateStr = '';
                              if (timestamp != null) {
                                final date = timestamp.toDate();
                                dateStr =
                                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                              }
                              return Center(
                                child: Container(
                                  width: 364,
                                  height: 114,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: const Color(0xFFBFC6FF),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    title: Text(
                                      promptTitle,
                                      style: const TextStyle(
                                        fontFamily: 'quicksand',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle:
                                        dateStr.isNotEmpty
                                            ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: Text(
                                                    dateStr,
                                                    style: const TextStyle(
                                                      fontFamily: 'quicksand',
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ), // Increased space below date
                                              ],
                                            )
                                            : null,
                                    trailing: const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF7D7DDE),
                                      size: 28,
                                    ),
                                    onTap: null, // No edit functionality
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
