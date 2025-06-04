import 'package:flutter/material.dart';
import 'email_pw.dart';

class EnterInfoScreen extends StatefulWidget {
  const EnterInfoScreen({super.key});

  @override
  State<EnterInfoScreen> createState() => _EnterInfoScreenState();
}

class _EnterInfoScreenState extends State<EnterInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  void _goToEmailPasswordScreen() {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String occupation = _occupationController.text.trim();

    if (name.isEmpty || age.isEmpty || occupation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EmailPasswordScreen(
              name: name,
              age: age,
              occupation: occupation,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Custom back arrow
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 64.0),
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'quicksand',
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'We\'ll use this information to personalise your experience and ensure you get suggestions suited to you.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontFamily: 'quicksand',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 56.0),
              const Text(
                'First, what should we call you?',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 4.0),
              // Name field with shadow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontFamily: 'quicksand'),
                  decoration: InputDecoration(
                    hintText: 'e.g. Jerry',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(137, 146, 139, 139),
                      fontFamily: 'quicksand',
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Color(0xFF9F7AEA),
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'How old are you?',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 4.0),
              // Age field with shadow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: 'quicksand'),
                  decoration: InputDecoration(
                    hintText: 'e.g. 19',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(137, 146, 139, 139),
                      fontFamily: 'quicksand',
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Color(0xFF9F7AEA),
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'What do you do?',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'quicksand',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 4.0),
              // Occupation field with shadow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _occupationController,
                  style: const TextStyle(fontFamily: 'quicksand'),
                  decoration: InputDecoration(
                    hintText: 'e.g. Student, Engineer, Artist...',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(137, 146, 139, 139),
                      fontFamily: 'quicksand',
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Color(0xFF9F7AEA),
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 16.0, color: Colors.black38),
                  SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      'Knowing what you do helps us understand what you\'re balancing',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black38,
                        fontFamily: 'quicksand',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF9F7AEA),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.12),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _goToEmailPasswordScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
