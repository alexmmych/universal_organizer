import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_organizer/color_theme.dart';

import 'package:hive/hive.dart';

class TopBar extends StatefulWidget {
  final ValueNotifier<Brightness> brightness;

  const TopBar({
    super.key,
    required this.brightness,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  var theme = getNightMode();

  void changeTheme() {
    setState(() {
      // Sets the theme for the app
      theme = (theme == BackgroundForeground.dayTheme
          ? BackgroundForeground.nightTheme
          : BackgroundForeground.dayTheme);

      // Changes the brightness type
      widget.brightness.value = (widget.brightness.value == Brightness.light
          ? Brightness.dark
          : Brightness.light);

      // Saves changes in hive settings box
      widget.brightness.value == Brightness.dark
          ? setNightMode(true)
          : setNightMode(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.background.secondary,
          title: const Text("Universal Organizer",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[
            Row(
              children: [
                Button(
                    theme: theme,
                    onPressed: changeTheme,
                    icon: widget.brightness.value == Brightness.dark
                        ? CupertinoIcons.sun_max
                        : CupertinoIcons.moon),
                Button(
                    theme: theme,
                    onPressed: () => print("Hello World"),
                    icon: CupertinoIcons.settings),
                // Small space between the buttons and the edge of the screen
                const SizedBox(width: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.theme,
    required this.icon,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final BackgroundForeground theme;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: theme.foreground.secondary,
        hoverColor: colorSelected,
        splashColor: theme.foreground.secondary,
        child: Icon(
          icon,
          color: theme.background.primary,
        ),
      ),
    );
  }
}

class BaseClass extends StatelessWidget {
  final ValueNotifier<Brightness> brightness;

  const BaseClass({
    super.key,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: brightness,
      builder: (context, brightnessValue, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: useMaterial3,
            brightness: brightnessValue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorSelected,
              brightness: brightnessValue,
            ),
          ),
          home: TopBar(brightness: brightness),
        );
      },
    );
  }
}

BackgroundForeground getNightMode() {
  var box = Hive.box('settings');

  return (box.get('night_mode', defaultValue: false)
      ? BackgroundForeground.nightTheme
      : BackgroundForeground.dayTheme);
}

// Function to toggle night mode
Future<void> setNightMode(bool isNightMode) async {
  var box = Hive.box('settings');
  await box.put('night_mode', isNightMode);
}
