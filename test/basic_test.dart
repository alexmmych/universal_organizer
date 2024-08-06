import 'package:universal_organizer/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Widget contains 'Hello World!' text", (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MainApp());

    // Create the Finders.
    final messageFinder = find.text('Hello World! TEST');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(messageFinder, findsOneWidget);
  });
}
