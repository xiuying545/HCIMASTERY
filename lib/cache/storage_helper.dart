import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> set(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
