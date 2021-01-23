import 'package:shared_preferences/shared_preferences.dart';

class FontSizePreference {
  static const fontSize = "fontSize";

  void setPreferredSize(double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setDouble(fontSize, value);
  }

  Future<double> getPreferredSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getDouble(fontSize) ?? 0.65;
  }
}
