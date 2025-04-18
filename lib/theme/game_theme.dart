import 'package:flutter/material.dart';

class GameTheme extends ThemeExtension<GameTheme> {
  final Map<int, Color> tileColors;
  final Map<int, Color> textColors;

  final Color appBar;
  final Color gridColor;
  final Color gridBackground;
  final Color extraTile;
  final Color activeButton;
  final Color inactiveButton;
  final Color lightText;
  final Color darkText;
  final Color actionButton;

  const GameTheme({
    required this.appBar,
    required this.tileColors,
    required this.textColors,
    required this.gridColor,
    required this.gridBackground,
    required this.extraTile,
    required this.activeButton,
    required this.inactiveButton,
    required this.lightText,
    required this.darkText,
    required this.actionButton,
  });

  @override
  GameTheme copyWith({
    Map<int, Color>? tileColors,
    Map<int, Color>? textColors,
    Color? appBar,
    Color? gridColor,
    Color? gridBackground,
    Color? extraTile,
    Color? activeButton,
    Color? inactiveButton,
    Color? lightText,
    Color? darkText,
    Color? actionButton,
  }) {
    return GameTheme(
      tileColors: tileColors ?? this.tileColors,
      textColors: textColors ?? this.textColors,
      appBar: appBar ?? this.appBar,
      gridColor: gridColor ?? this.gridColor,
      gridBackground: gridBackground ?? this.gridBackground,
      extraTile: extraTile ?? this.extraTile,
      activeButton: activeButton ?? this.activeButton,
      inactiveButton: inactiveButton ?? this.inactiveButton,
      lightText: lightText ?? this.lightText,
      darkText: darkText ?? this.darkText,
      actionButton: actionButton ?? this.actionButton,
    );
  }

  @override
  GameTheme lerp(ThemeExtension<GameTheme>? other, double t) => this;
}