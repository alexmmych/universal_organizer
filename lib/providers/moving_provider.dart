import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MovingProvider extends ChangeNotifier {
  bool isShown = false; // Default value
  late Box box; // Hive box for storing settings

  MovingProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  void _loadSettings() async {
    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  // Function to toggle the moving container animation
  void toggle() {
    isShown = !isShown;
    box.put('isShown', isShown); // Save the new value to Hive
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
