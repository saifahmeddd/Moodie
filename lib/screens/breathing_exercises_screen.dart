import 'package:flutter/material.dart';

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5AE0),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 40,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF6A5AE0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Text(
                'Breathing Exercises',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                  children: [
                    _ExerciseCard(
                      title: 'Box Breathing',
                      duration: '4 minutes',
                      focusArea: 'Stress & Anxiety',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: '4-7-8 Breathing',
                      duration: '3 minutes',
                      focusArea: 'Sleep & Panic Relief',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: 'Tactical Breathing',
                      duration: '5 minutes',
                      focusArea: 'High-Stress Situations',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: 'Double Inhale and Sigh',
                      duration: '2 minutes',
                      focusArea: 'Quick Reset',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: 'Diaphragmatic Breathing',
                      duration: '5 minutes',
                      focusArea: 'Relaxation',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: '3-3-3 Breathing',
                      duration: '3 minutes',
                      focusArea: 'Grounding',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                    const SizedBox(height: 24),
                    _ExerciseCard(
                      title: 'Coherent Breathing',
                      duration: '6 minutes',
                      focusArea: 'Balance & Calm',
                      imageAsset: 'assets/images/meditation.svg',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String title;
  final String duration;
  final String focusArea;
  final String imageAsset;

  const _ExerciseCard({
    required this.title,
    required this.duration,
    required this.focusArea,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFD1C4E9), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Duration:',
                      style: TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Focus Area:',
                      style: TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      focusArea,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Text',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Replace with SvgPicture.asset(imageAsset) if using SVGs
          SizedBox(
            height: 90,
            width: 90,
            child: Image.asset(
              'assets/images/img1.png', // Placeholder, replace with your asset
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
