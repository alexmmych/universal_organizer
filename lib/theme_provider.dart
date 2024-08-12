import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default value
  Color _seedColor = Colors.blue; // Default seed color for the theme
  late Box settingsBox; // Hive box for storing settings

  ThemeProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  ThemeData get themeData => _createThemeData();

  // Load settings from Hive
  void _loadSettings() async {
    settingsBox = await Hive.openBox('settings');
    _isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  // Function to toggle between light and dark mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    settingsBox.put('isDarkMode', _isDarkMode); // Save the new value to Hive
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Function to change the seed color
  void changeSeedColor(Color newColor) {
    _seedColor = newColor;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Create the ThemeData based on the current state
  ThemeData _createThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      highlightColor: _isDarkMode ? Colors.orangeAccent : Colors.blueAccent,
    );
  }
}
