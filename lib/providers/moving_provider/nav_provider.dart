import 'package:hive/hive.dart';

import 'moving_provider.dart';

class NavProvider extends MovingProvider {
  int selectedIndex = 0;

  NavProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  void _loadSettings() async {
    box = Hive.box('navigation_settings');
    isShown = box.get('isShown', defaultValue: false);
    selectedIndex = box.get('selectedIndex', defaultValue: 0);

    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  // Update index to selected value
  void setIndex(value) {
    selectedIndex = value;
    box.put('selectedIndex', selectedIndex);

    notifyListeners();
  }
}
