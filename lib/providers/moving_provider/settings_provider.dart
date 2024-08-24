import 'package:hive/hive.dart';

import 'moving_provider.dart';

class SettingsProvider extends MovingProvider {
  String name = "";
  String pictureURI = "";

  bool loggedIn = false;
  bool requestLogIn = false;

  late Box googleUser;

  SettingsProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  Future<void> _loadSettings() async {
    box = Hive.box('settings');
    isShown = box.get('isShown', defaultValue: false);

    googleUser = Hive.box("google_user");

    final credentialsJson = googleUser.get('credentials');

    if (credentialsJson != null) {
      name = googleUser.get("name", defaultValue: "");
      pictureURI = googleUser.get("picture", defaultValue: "");
      loggedIn = true;
    } else {
      loggedIn = false;
    }
  }

  void logout() async {
    await googleUser.clear();

    loggedIn = false;
    notifyListeners();
  }

  void requestLogin() async {
    requestLogIn = true;
    notifyListeners();
  }

  void login() async {
    await _loadSettings();

    notifyListeners();
  }
}
