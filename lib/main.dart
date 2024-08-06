import 'package:flutter/material.dart';

import 'package:universal_organizer/widgets.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BaseClass(
      brightness: ValueNotifier(Brightness.light),
    );
  }
}
