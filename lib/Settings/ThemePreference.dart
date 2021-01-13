

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference{

  static const isDark = "isDark";

  void setPreferredTheme(bool value)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    

    pref.setBool(isDark, value);
  }

  Future<bool> getPreferredTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool(isDark) ?? false ;
  }
}