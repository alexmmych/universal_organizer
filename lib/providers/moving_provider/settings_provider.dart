import 'package:hive/hive.dart';

import 'moving_provider.dart';

class SettingsProvider extends MovingProvider {
  String name = "";
  String pictureURI = "";

  bool loggedIn = false;

  late Box googleUser;
  late Box _googleUserCache;

  SettingsProvider() {
    _loadSettings(); // Load settings from Hive on initialization
  }

  // Load settings from Hive
  void _loadSettings() async {
    box = await Hive.openBox('settings');
    isShown = box.get('isShown', defaultValue: false);

    googleUser = await Hive.openBox("google_user");
    _googleUserCache = await Hive.openBox("google_user_cache");

    final credentialsJson = googleUser.get('credentials');

    if (credentialsJson != null) {
      name = googleUser.get("name");
      pictureURI = googleUser.get("picture");
      loggedIn = true;
    }

    notifyListeners(); // Notify listeners to rebuild UI with the loaded theme
  }

  void _transferBetweenBoxes(boxA, boxB) async {
    for (var key in boxA) {
      var value = boxA.get(key);
      await boxB.put(key, value);
    }
  }

  void logout() async {
    _transferBetweenBoxes(googleUser, _googleUserCache);
    await googleUser.clear();

    loggedIn = false;
    notifyListeners();
  }

  void login() async {
    _transferBetweenBoxes(_googleUserCache, googleUser);
    await _googleUserCache.clear();

    loggedIn = true;
    notifyListeners();
  }
}
