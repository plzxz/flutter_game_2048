import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade400,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade600
  )
);

ThemeData blueMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    background: Colors.blue.shade900,
    primary: Colors.blue.shade800,
    secondary: Colors.blue.shade700,
    tertiary: Colors.blue.shade600
  )
);

ThemeData NormalMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    background: Colors.orange.shade200,
    primary: Colors.grey.shade100,
    secondary: Colors.orange.shade700,
    tertiary: Colors.orange.shade600
  )
);