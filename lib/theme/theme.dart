import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/tile_color.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xFFFFFFFF),
    primary: Colors.grey.shade400,
    secondary: Colors.grey.shade300,
    tertiary: Colors.grey.shade100,
  ),
  extensions: <ThemeExtension<dynamic>>[
    lightGameTheme,
  ],
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    background: Color(0xFF404040),
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade600,
    tertiary: Colors.grey.shade800
  ),
  extensions: <ThemeExtension<dynamic>>[
    darkGameTheme,
  ],
);

ThemeData blueMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    background: Color(0xFFDAE7EE),
    primary: Colors.blue.shade600,
    secondary: Colors.blue.shade400,
    tertiary: Colors.blue.shade500
  ),
  extensions: <ThemeExtension<dynamic>>[
    blueGameTheme,
  ],
);

ThemeData NormalMode = ThemeData(
  brightness: Brightness.light,
    colorScheme: ColorScheme.light(
    background: Color(0xFFEEE4DA),
    primary: Color(0xFFF57C5F),
    secondary: Color(0xFF776E65),
    tertiary: Color(0xFFCDC1B4)
  ),
  extensions: <ThemeExtension<dynamic>>[
    normalGameTheme,
  ],
);

ThemeData CrismasMode = ThemeData(
  brightness: Brightness.light,
    colorScheme: ColorScheme.light(
    background: Color(0xFF9BBE62),
    primary: Color(0xFF226A5E),
    secondary: Color(0xFFC71415),
    tertiary: Color(0xFFF4A901)
  ),
  extensions: <ThemeExtension<dynamic>>[
    chistmasGameTheme,
  ],
);