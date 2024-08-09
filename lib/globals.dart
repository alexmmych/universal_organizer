import 'package:flutter/material.dart';

bool useMaterial3 = true;
Color colorSelected = Colors.blue;

class SelectedColor {
  final Color primary;
  final Color secondary;

  const SelectedColor(this.primary, this.secondary);
}

const SelectedColor dayTheme = SelectedColor(Colors.white, Colors.white54);
const SelectedColor nightTheme = SelectedColor(Colors.black, Colors.black54);
