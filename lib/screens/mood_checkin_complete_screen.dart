import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodCheckinCompleteScreen extends StatelessWidget {
  const MoodCheckinCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.only(top: 74.0, left: 24.0, right: 24.0),
              child: Text(
                'One step closer to\nknowing yourself!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  letterSpacing: -0.7,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 351,
              width: 351,
              child: SvgPicture.asset(
                'assets/images/growing.svg',
                fit: BoxFit.contain,
                placeholderBuilder: (context) => const SizedBox.shrink(),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7D7DDE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Return Home',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'General Sans',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.north_east_rounded, size: 20),
                    ],
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
