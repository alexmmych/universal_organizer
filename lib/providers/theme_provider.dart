import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false; // Default value
  Color _seedColor = Colors.blue; // Default seed color for the theme
  late Box settingsBox; // Hive box for storing settings

  ThemeProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  ThemeData get themeData => _createThemeData();

  // Load settings from Hive
  void _loadSettings() async {
    settingsBox = await Hive.openBox('settings');
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  // Function to toggle between light and dark mode
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    settingsBox.put('isDarkMode', isDarkMode); // Save the new value to Hive
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Function to change the seed color
  void changeSeedColor(Color newColor) {
    _seedColor = newColor;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  Color getOppositeColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  // Create the ThemeData based on the current state
  ThemeData _createThemeData() {
    return ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        highlightColor: _seedColor,
        hoverColor: _seedColor,
        splashColor: isDarkMode
            ? const Color.fromARGB(255, 64, 66, 69)
            : const Color.fromARGB(255, 220, 221, 221));
  }
}
