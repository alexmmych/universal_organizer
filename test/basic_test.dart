import 'package:universal_organizer/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:universal_organizer/widgets.dart';

void main() {
  testWidgets("App and TopBar exist", (tester) async {
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

  testWidgets("App and TopBar elements work as expected", (tester) async {
    // Initialize the ValueNotifier with light mode
    final brightnessNotifier = ValueNotifier<Brightness>(Brightness.light);

    // Build the widget with the brightnessNotifier as a value we can monitor
    await tester.pumpWidget(BaseClass(brightness: brightnessNotifier));

    // Get the night mode button
    final buttonFinder = find.byType(FloatingActionButton);

    // Ensure that the application starts in light mode
    expect(brightnessNotifier.value, equals(Brightness.light));

    // Click on the button
    await tester.tap(buttonFinder);

    // Wait for animations to stop
    await tester.pumpAndSettle();

    // The brightness should change to dark after clicking the button on start
    expect(brightnessNotifier.value, equals(Brightness.dark));
  });
}
