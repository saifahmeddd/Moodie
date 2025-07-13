import 'package:flutter/material.dart';
import 'email_pw.dart';
import '../widgets/custom_back_button.dart';

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 176.0,
                  ), // Increased from 64.0 to create space below back button
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
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
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
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
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
                          offset: const Offset(0, 2),
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
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
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.0,
                        color: Colors.black38,
                      ),
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
                  const SizedBox(
                    height: 32.0,
                  ), // Increased padding above the next button
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF7D7DDE),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Less rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
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
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Less rounded corners
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
            // Custom back arrow positioned at top 4.5px and left 0px
            Positioned(
              top: 12.0,
              left: 3,
              child: CustomBackButton(iconColor: Colors.black87, iconSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
