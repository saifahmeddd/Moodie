import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_back_button.dart';
import 'signup_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? age;
  String? occupation;
  String chatbotName = "Nova";
  bool motivationalQuotes = true;
  String journalPromptFrequency = "Weekly";
  List<String> focusAreas = ["Academic Stress", "Focus & Productivity"];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("No user logged in.");
      String uid = currentUser.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? 'User';
          age = userDoc['age'] ?? 'N/A';
          occupation = userDoc['occupation'] ?? 'N/A';
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        name = 'User';
        age = 'N/A';
        occupation = 'N/A';
      });
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("No user logged in.");
      String uid = currentUser.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        field: value,
      });

      setState(() {
        if (field == 'name') name = value;
        if (field == 'age') age = value;
        if (field == 'occupation') occupation = value;
      });
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> _updateFocusAreas(List<String> focusAreas) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("No user logged in.");
      String uid = currentUser.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'focusAreas': focusAreas,
      });
    } catch (e) {
      print('Error updating focus areas: $e');
    }
  }

  void _showEditDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Edit $field'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter new $field'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateUserData(field, controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false, // Removed the default back button
          leading: CustomBackButton(iconColor: Colors.grey[800], iconSize: 24),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header at top
              Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFBFD7FF),
                    child: Icon(Icons.person, size: 60, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildEditableInfoSection("Name", name ?? 'Loading...', 'name'),
              _buildEditableInfoSection("Age", age ?? 'Loading...', 'age'),
              _buildEditableInfoSection(
                "Occupation",
                occupation ?? 'Loading...',
                'occupation',
              ),

              const SizedBox(height: 20),

              _buildSectionHeader("App Preferences"),

              _buildToggleTile(
                title: "Motivational Quotes",
                subtitle: "Show on login?",
                value: motivationalQuotes,
                onChanged: (val) => setState(() => motivationalQuotes = val),
              ),

              const SizedBox(height: 16),

              _buildSectionHeader("Focus Areas"),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    ...[
                      "Academic Stress",
                      "Work Burnout",
                      "Anxiety / Overthinking",
                      "Focus & Productivity",
                      "Emotional Regulation",
                    ].map(_buildFocusAreaCheckbox),
                  ],
                ),
              ),

              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const SignupLoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Colors.indigo, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoSection(String label, String value, String field) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.white,
      title: Text(label),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.indigo),
        onPressed: () => _showEditDialog(field, value),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.indigo,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildFocusAreaCheckbox(String label) {
    bool isChecked = focusAreas.contains(label);

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 10)), // Smaller text
      value: isChecked,
      onChanged: (val) {
        setState(() {
          if (val == true) {
            if (!focusAreas.contains(label)) {
              focusAreas.add(label);
            }
          } else {
            focusAreas.remove(label);
          }
          _updateFocusAreas(focusAreas); // Update in Firestore
        });
      },
      activeColor: Colors.indigo,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}
