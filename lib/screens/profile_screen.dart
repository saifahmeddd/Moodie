import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_back_button.dart';
import 'signup_login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool motivationalQuotes = false;
  String journalPromptFrequency = "Weekly";
  List<String> focusAreas = ["Academic Stress", "Focus & Productivity"];

  final List<String> journalPromptOptions = [
    "Daily",
    "Weekly",
    "Monthly",
    "Off",
  ];

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
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(
            iconColor: Colors.grey[800],
            iconSize: 24,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar and Name at the top
              const SizedBox(height: 8),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFB1AFFF), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundColor: Color(0xFFE6E6FA),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Editable Profile Fields
              _buildProfileFieldsCard(),
              const SizedBox(height: 28),
              // App Preferences
              _buildSectionTitle("App preferences"),
              const SizedBox(height: 8),
              _buildNotificationsCard(),
              const SizedBox(height: 24),
              // Chatbot Name
              _buildSectionTitle("Chatbot Name"),
              const SizedBox(height: 8),
              _buildChatbotNameCard(),
              const SizedBox(height: 24),
              // Focus Areas
              _buildSectionTitle("Focus Areas"),
              const SizedBox(height: 8),
              _buildFocusAreasCard(),
              const SizedBox(height: 24),
              // Privacy & Data
              _buildSectionTitle("Privacy & Data"),
              const SizedBox(height: 8),
              _buildPrivacyDataCard(),
              const SizedBox(height: 32),
              // Logout Button
              Center(
                child: ElevatedButton.icon(
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
                  label: const Text(
                    "Log Out",
                    style: TextStyle(
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7D7DDE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileFieldsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ), // reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableFieldRow("Name", name ?? 'Loading...', 'name'),
          const SizedBox(height: 8), // reduced spacing
          _buildEditableFieldRow("Age", age ?? 'Loading...', 'age'),
          const SizedBox(height: 8), // reduced spacing
          _buildEditableFieldRow(
            "Occupation",
            occupation ?? 'Loading...',
            'occupation',
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFieldRow(String label, String value, String field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'General Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2), // reduced spacing
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ), // reduced vertical padding
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F6FB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(value, style: const TextStyle(fontSize: 15)),
              ),
            ),
            TextButton(
              onPressed: () => _showEditDialog(field, value),
              child: const Text(
                "Change",
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Motivational quotes",
                    style: TextStyle(
                      fontFamily: 'General Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Show on login?",
                    style: TextStyle(
                      fontFamily: 'General Sans',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Switch(
                value: motivationalQuotes,
                onChanged: (val) => setState(() => motivationalQuotes = val),
                activeColor: Colors.indigo,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Journal prompt reminder",
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ), // reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F6FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  value: journalPromptFrequency,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(8),
                  isDense: true, // make dropdown more compact
                  style: const TextStyle(
                    fontFamily: 'General Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  items:
                      journalPromptOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontFamily: 'General Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) journalPromptFrequency = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotNameCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Current Name",
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ), // reduced padding
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6FB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              chatbotName,
              style: const TextStyle(
                fontFamily: 'General Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusAreasCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
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
    );
  }

  Widget _buildFocusAreaCheckbox(String label) {
    bool isChecked = focusAreas.contains(label);
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'General Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
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
          _updateFocusAreas(focusAreas);
        });
      },
      activeColor: Colors.indigo,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }

  Widget _buildPrivacyDataCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Clear History",
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7F6FB),
                  foregroundColor: Colors.indigo,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  "Clear",
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reset mood tracker",
                style: TextStyle(
                  fontFamily: 'General Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7F6FB),
                  foregroundColor: Colors.indigo,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    fontFamily: 'General Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
