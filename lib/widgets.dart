import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:universal_organizer/globals.dart';

// ChatGPT used here to make ValueNotifier and their builders
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
  var theme = BackgroundForeground.dayTheme;

  void changeTheme() {
    setState(() {
      theme = (theme == BackgroundForeground.dayTheme
          ? BackgroundForeground.nightTheme
          : BackgroundForeground.dayTheme);

      widget.brightness.value = (widget.brightness.value == Brightness.light
          ? Brightness.dark
          : Brightness.light);
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
                Button(theme: theme, widget: widget, onPressed: changeTheme),
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
    required this.widget,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final BackgroundForeground theme;
  final TopBar widget;

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
        child: ValueListenableBuilder<Brightness>(
          valueListenable: widget.brightness,
          builder: (context, brightness, child) {
            return Icon(
              brightness == Brightness.dark
                  ? CupertinoIcons.sun_max
                  : CupertinoIcons.moon,
              color: theme.background.primary,
            );
          },
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
