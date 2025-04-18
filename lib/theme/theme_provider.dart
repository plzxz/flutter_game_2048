import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int select = 0;

  ThemeData _themeData = NormalMode;

  ThemeData get themeData => _themeData;

  int get selectTheme => select;

  Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  select = prefs.getInt('themeSelect') ?? 0;
  print("theme: $select");

  if (select == 0) {
    _themeData = NormalMode;
  } else if (select == 1) {
    _themeData = lightMode;
  } else if (select == 2) {
    _themeData = darkMode;
  } else if (select == 3) {
    _themeData = blueMode;
  } else if (select == 4) {
    _themeData = CrismasMode;
  }
  notifyListeners();
}

  void _saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeSelect', value);
    print(value);
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

  void changeTheme(int value) {
    if(value == 0) {
      select = 0;
      themeData = NormalMode;
    } else if(value == 1) {
            select = 1;
      themeData = lightMode;
    } else if(value == 2) {
            select = 2;
      themeData = darkMode;
    } else if(value == 3) {
            select = 3;
      themeData = blueMode;
    } else if(value == 4) {
            select = 4;
      themeData = CrismasMode;
    }
    _saveTheme(select);
  }

  void toggleTheme() {
    if(select == 0) {
      themeData = lightMode;
      select++;
    } else if(select == 1) {
      themeData = darkMode;
      select++;
    } else if(select == 2) {
      themeData = blueMode;
      select++;
    } else if(select == 3) {
      themeData = CrismasMode;
      select++;
    } else if(select == 4) {
      themeData = NormalMode;
      select = 0;
    }
    _saveTheme(select);
  }

}