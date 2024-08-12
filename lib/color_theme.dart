import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

bool useMaterial3 = true;
Color colorSelected = const Color.fromARGB(255, 125, 125, 125);

class ColorTheme {
  final Color primary;
  final Color secondary;

  // Private constructor
  const ColorTheme._(this.primary, this.secondary);

  // Predefined color themes
  static const ColorTheme whiteTheme =
      ColorTheme._(Colors.white, Colors.white54);
  static const ColorTheme blackTheme =
      ColorTheme._(Colors.black, Colors.black54);
}

class BackgroundForeground {
  final ColorTheme background;
  final ColorTheme foreground;

  // Private constructor
  const BackgroundForeground._(this.background, this.foreground);

  // Predefined themes
  static const BackgroundForeground dayTheme =
      BackgroundForeground._(ColorTheme.blackTheme, ColorTheme.whiteTheme);

  static const BackgroundForeground nightTheme =
      BackgroundForeground._(ColorTheme.whiteTheme, ColorTheme.blackTheme);
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

// Function to toggle night mode
Future<void> setNavRail(bool isShown) async {
  var box = Hive.box('settings');
  await box.put('nav_rail', isShown);
}

bool getNavRail() {
  var box = Hive.box('settings');
  return box.get('nav_rail', defaultValue: false);
}
