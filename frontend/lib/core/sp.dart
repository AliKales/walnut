import 'package:shared_preferences/shared_preferences.dart';

final class SP {
  const SP._();

  static late SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static T? get<T>(String key) {
    return _pref.get(key) as T?;
  }

  static void set<T>(String key, T value) {
    switch (T) {
      case String:
        _pref.setString(key, value as String);
        break;
      case int:
        _pref.setInt(key, value as int);
        break;
      case bool:
        _pref.setBool(key, value as bool);
        break;
      case double:
        _pref.setDouble(key, value as double);
        break;
    }
  }
}
