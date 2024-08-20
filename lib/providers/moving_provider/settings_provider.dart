import 'package:hive/hive.dart';

import 'moving_provider.dart';

class SettingsProvider extends MovingProvider {
  String name = "";
  String pictureURI = "";

  late Box googleUser;

  SettingsProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  void _loadSettings() async {
    box = await Hive.openBox('settings');
    isShown = box.get('isShown', defaultValue: false);

    googleUser = await Hive.openBox("google_user");

    name = googleUser.get("name");
    pictureURI = googleUser.get("picture");

    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  void logout() async {
    await googleUser.clear();
    notifyListeners();
  }
}
