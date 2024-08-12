import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

bool useMaterial3 = true;
Color colorSelected = Colors.blue;

// Function to toggle night mode
Future<void> setNavRail(bool isShown) async {
  var box = Hive.box('settings');
  await box.put('nav_rail', isShown);
}

bool getNavRail() {
  var box = Hive.box('settings');
  return box.get('nav_rail', defaultValue: false);
}
