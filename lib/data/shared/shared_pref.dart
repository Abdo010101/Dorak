import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPref> getInstance() async {
    _instance ??= SharedPref();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }
}
