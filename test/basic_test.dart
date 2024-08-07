import 'package:universal_organizer/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:universal_organizer/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';

class MockBox extends Mock implements Box {}

void main() async {
  setUp(() async {
    await Hive.initFlutter();
  });

  test("Example test with Hive and Mockito", () async {
    final mockBox = MockBox();

    when(mockBox.get('key')).thenReturn('mocked value');
    when(mockBox.put('key', any)).thenAnswer((_) async {});

    // Perform operations
    final value = mockBox.get('key');

    // Assertions
    expect(value, 'mocked value');
  });

  testWidgets("App and TopBar exist", (tester) async {
    // Create the widget by telling the tester to build it.

    await tester.pumpWidget(const App());

    // Wait for indicator to stop spinning
    await tester.pumpAndSettle(); // Wait for refresh indicator to stop spinning

    // Create the Finders.
    final messageFinder = find.text('Universal Organizer');
    final buttonFinder = find.byType(FloatingActionButton);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(messageFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });

  testWidgets("App and TopBar elements work as expected", (tester) async {
    await Hive.openBox('settings');

    var box = await Hive.box('settings');

    bool isDarkMode = box.get('night_mode', defaultValue: false) ?? false;
    final brightnessNotifier = ValueNotifier<Brightness>(
        isDarkMode ? Brightness.dark : Brightness.light);

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
