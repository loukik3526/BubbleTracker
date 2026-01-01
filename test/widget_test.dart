// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bubbletrack/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FloatApp());

    // Verify that the app builds and shows the home screen.
    // We can look for the FAB or just ensure no errors occur.
    expect(find.byType(MaterialApp), findsOneWidget);
    // Since we have a glass FAB with an add icon
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
