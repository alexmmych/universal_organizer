import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_organizer/providers/moving_provider/moving_provider.dart';
import 'package:universal_organizer/providers/moving_provider/settings_provider.dart';

import 'widgets/base_class.dart';

import 'providers/theme_provider.dart';
import 'providers/moving_provider/nav_provider.dart';

void main() async {
  // ChatGPT best practice recommendation for ensureInitialized
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Initialize Hive with Flutter
  await Hive.openBox('settings');
  await Hive.openBox('google_user');
  await Hive.openBox('notes');
  await Hive.openBox('reminders');

  //MultiProvider suggested by ChatGPT when asked how to have several ChangeNotifier Providers
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MovingProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NavProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
      ),
    ],
    child: const App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return BaseClass(theme: themeProvider.themeData);
    });
  }
}
