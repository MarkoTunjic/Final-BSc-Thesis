import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utilities/global_variables.dart' as globals;
import '../models/constants/shared_preferences_keys.dart' as keys;

class SharedPreferencesHelper {
  static Future<void> readSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.started = prefs.getBool(keys.startedKey) ?? false;
    String? userJson = prefs.getString(keys.user);
    if (userJson != null) {
      globals.loggedInUser = User.fromJSON(jsonDecode(userJson));
    }
    globals.token = prefs.getString(keys.token);
  }

  static Future<void> removeSharedPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
