import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreference {
  static const key = "isNotificationEnabled";

  void setPreference(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool(key, value);
  }

  Future<bool> getPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool(key) ?? true;
  }
}
