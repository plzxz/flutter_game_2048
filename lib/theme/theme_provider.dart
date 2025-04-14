import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int select = 0;

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  void loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  select = prefs.getInt('themeSelect') ?? 0;

  if (select == 0) {
    _themeData = lightMode;
  } else if (select == 1) {
    _themeData = darkMode;
  } else if (select == 2) {
    _themeData = blueMode;
  } else if (select == 3) {
    _themeData = NormalMode;
  }
  notifyListeners();
}

  void _saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeSelect', value);
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // void toggleTheme() {
  //   if(_themeData == lightMode) {
  //     themeData = darkMode;
  //   } else {
  //     themeData = lightMode;
  //   }
  // }

  void toggleTheme() {
    if(select == 0) {
      themeData = darkMode;
      select++;
    } else if(select == 1) {
      themeData = blueMode;
      select++;
    } else if(select == 2) {
      themeData = NormalMode;
      select++;
    } else if(select == 3) {
      themeData = lightMode;
      select = 0;
    }
    _saveTheme(select);
  }

}