import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/global_variables.dart' as globals;
import '../models/constants/shared_preferences_keys.dart' as keys;

class SharedPreferencesHelper {
  static Future<void> readSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.started = prefs.getBool(keys.startedKey) ?? false;
  }
}
