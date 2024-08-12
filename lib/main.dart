import 'package:flutter/material.dart';
import 'base_class.dart';
import 'theme_provider.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // Initialize Hive with Flutter
  await Hive.openBox('settings');

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
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
