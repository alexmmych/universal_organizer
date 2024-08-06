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
  var foregroundTheme = dayTheme;
  var backgroundTheme = nightTheme;

  void changeTheme() {
    setState(() {
      var tempColor = foregroundTheme;

      foregroundTheme = backgroundTheme;
      backgroundTheme = tempColor;

      widget.brightness.value = (widget.brightness.value == Brightness.dark
          ? Brightness.light
          : Brightness.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundTheme.secondary,
          title: const Text("Universal Organizer",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[
            Container(
              height: 40.0,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
              child: FloatingActionButton(
                onPressed: changeTheme,
                shape: const CircleBorder(),
                backgroundColor: foregroundTheme.secondary,
                hoverColor: colorSelected,
                splashColor: foregroundTheme.secondary,
                child: ValueListenableBuilder<Brightness>(
                  valueListenable: widget.brightness,
                  builder: (context, brightness, child) {
                    return Icon(
                      brightness == Brightness.dark
                          ? CupertinoIcons.moon
                          : CupertinoIcons.sun_max,
                      color: backgroundTheme.primary,
                    );
                  },
                ),
              ),
            ),
          ],
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
