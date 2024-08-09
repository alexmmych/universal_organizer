import 'package:flutter/material.dart';
import 'package:universal_organizer/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive with Flutter
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('settings'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BaseClass(
              brightness: ValueNotifier(_getThemeBrightness()),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}

Brightness _getThemeBrightness() {
  var box = Hive.box('settings');
  // Retrieve the value with a default of false if it's null
  bool isDarkMode = box.get('night_mode', defaultValue: false) ?? false;
  return isDarkMode ? Brightness.dark : Brightness.light;
}
