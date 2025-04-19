import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodie_v2/main.dart';

void main() {
  testWidgets('MoodieApp builds and displays SignInPage', (
    WidgetTester tester,
  ) async {
    // Build the Moodie app
    await tester.pumpWidget(const MoodieApp());

    // Verify that the Scaffold and button exist
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Sign in Anonymously'), findsOneWidget);
  });
}
