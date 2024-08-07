import 'package:flutter/material.dart';

bool useMaterial3 = true;
Color colorSelected = Colors.blue;

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
