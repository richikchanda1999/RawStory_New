import 'package:flutter/cupertino.dart';
import 'package:raw_story_new/Settings/SizePreference.dart';

class FontSizeProvider extends ChangeNotifier {
  FontSizePreference fontSizePreference = FontSizePreference();

  Future<double> get getCurrentSize async {
    return await fontSizePreference.getPreferredSize();
  }

  void setSize(double value) {
    fontSizePreference.setPreferredSize(value);

    notifyListeners();
  }
}
