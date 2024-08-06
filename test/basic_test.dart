import 'package:universal_organizer/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets("Top Bar is created and the button and title are shown",
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const App());

    // Create the Finders.
    final messageFinder = find.text('Universal Organizer');
    final buttonFinder = find.byType(FloatingActionButton);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(messageFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });
}
