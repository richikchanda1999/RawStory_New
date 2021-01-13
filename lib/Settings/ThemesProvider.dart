


import 'package:flutter/cupertino.dart';
import 'package:raw_story_new/Settings/ThemePreference.dart';

class ThemeProvider extends ChangeNotifier{

  ThemePreference themePreference = ThemePreference();

  Future<bool> get getCurrentTheme async { 
    
    
    return await themePreference.getPreferredTheme();

  }

  void setTheme(bool value){
    themePreference.setPreferredTheme(value);
 

    notifyListeners();
  }
  
}