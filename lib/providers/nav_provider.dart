import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NavProvider extends ChangeNotifier {
  bool isShown = false; // Default value
  int selectedIndex = 0;
  late Box settingsBox; // Hive box for storing settings

  NavProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  void _loadSettings() async {
    settingsBox = await Hive.openBox('settings');
    isShown = settingsBox.get('isShown', defaultValue: false);
    selectedIndex = settingsBox.get('selectedIndex', defaultValue: 0);

    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  void setIndex(value) {
    selectedIndex = value;
    settingsBox.put('selectedIndex', selectedIndex);
    notifyListeners();
  }

  // Function to toggle between showing the navigational rails and not
  void toggleNavBar() {
    isShown = !isShown;
    settingsBox.put('isShown', isShown); // Save the new value to Hive
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
