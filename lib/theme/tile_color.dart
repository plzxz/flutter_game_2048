import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';

const normalGameTheme = GameTheme(
  tileColors: {
    2: Color(0xFFEEE4DA),
    4: Color(0xFFEEE4DA),
    8: Color(0xFFF2B179),
    16: Color(0xFFF59563),
    32: Color(0xFFF57C5F),
    64: Color(0xFFF65F40),
    128: Color(0xFFEBD075),
    256: Color(0xFFEDCB67),
    512: Color(0xFFECC955),
    1024: Color(0xFFE5C25A),
    2048: Color(0xFFE8C046),
  },
  textColors: {
    2: Color(0xFF776E65),
    4: Color(0xFF776E65),
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.white,
  },
  appBar: Color(0xFF776E65),
  gridColor: Color(0xFFBBADA0),
  gridBackground: Color(0xFFCDC1B4),
  extraTile: Color(0xFFF34747),
  activeButton: Color(0xFF776E65),
  inactiveButton: Color(0xFFBDAD9D),
  lightText: Colors.white,
  darkText: Color(0xFF776E65),
  actionButton: Color(0xFFF67C5F),
);

const lightGameTheme = GameTheme(
  tileColors: {
    2: Color(0xFF777777),
    4: Color(0xFF777777),
    8: Color(0xFFE6E6E6),
    16: Color(0xFFD9D9D9),
    32: Color(0xFFCCCCCC),
    64: Color(0xFFBFBFBF),
    128: Color(0xFFB3B3B3),
    256: Color(0xFFA6A6A6),
    512: Color(0xFF999999),
    1024: Color(0xFF8C8C8C),
    2048: Color(0xFF808080),
    4096: Color(0xFF808080),
  },
  textColors: {
    2: Color(0xFFF2F2F2),
    4: Color(0xFFF2F2F2),
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.white,
  },
  appBar: Color(0xFFFFFFFF),
  gridColor: Color(0xFFB3B3B3),
  gridBackground: Color(0xFF636363),
  extraTile: Color(0xFF737373),
  activeButton: Color(0xFF636363),
  inactiveButton: Color(0xFFB3B3B3),
  darkText: Colors.white,
  lightText: Color(0xFF777777),
  actionButton: Color(0xFF404040),
);

const darkGameTheme = GameTheme(
  tileColors: {
    2: Color(0xFFE6E6E6),
    4: Color(0xFFE6E6E6),
    8: Color(0xFFB3B3B3),
    16: Color(0xFF999999),
    32: Color(0xFF808080),
    64: Color(0xFF737373),
    128: Color(0xFF666666),
    256: Color(0xFF595959),
    512: Color(0xFF4D4D4D),
    1024: Color(0xFF404040),
    2048: Color(0xFF333333),
    4096: Color(0xFF000000),
  },
  textColors: {
    2: Color(0xFF777777),
    4: Color(0xFF777777),
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.white,
  },
  appBar: Color(0xFF1A1A1A),
  gridColor: Color(0xFF8C8C8C),
  gridBackground: Color(0xFFBFBFBF),
  extraTile: Colors.black,
  activeButton: Color(0xFF666666),
  inactiveButton: Color(0xFFB3B3B3),
  lightText: Colors.white,
  darkText: Color(0xFF777777),
  actionButton: Color(0xFFBFBFBF),
);

const blueGameTheme = GameTheme(
  tileColors: {
    2: Color(0xFFDAE7EE),
    4: Color(0xFFDAE7EE),
    8: Color(0xFF79CAF2),
    16: Color(0xFF63B8F5),
    32: Color(0xFF5FAAF5),
    64: Color(0xFF408CF6),
    128: Color(0xFF7589EB),
    256: Color(0xFF677DED),
    512: Color(0xFF556EEC),
    1024: Color(0xFF5A71E5),
    2048: Color(0xFF4661E8),
    4096: Color(0xFF5347F3),
  },
  textColors: {
    2: Color(0xFF657177),
    4: Color(0xFF657177),
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.white,
  },
  appBar: Color(0xFF657177),
  gridColor: Color(0xFFB4C5CD),
  gridBackground: Color(0xFFA0B2BB),
  extraTile: Color(0xFF5347F3),
  activeButton: Color(0xFF657177),
  inactiveButton: Color(0xFF91A0A7),
  lightText: Colors.white,
  darkText: Color(0xFF657177),
  actionButton: Color(0xFF63B8F5),
);

const chistmasGameTheme = GameTheme(
  tileColors: {
    2: Color(0xFFA42423),
    4: Color(0xFFF4A901),
    8: Color(0xFF0AAA4A),
    16: Color(0xFF0C6F30),
    32: Color(0xFF253267),
    64: Color(0xFF1A2749),
    128: Color(0xFFF4392D),
    256: Color(0xFFA42621),
    512: Color(0xFFC71415),
    1024: Color(0xFF3462D),
    2048: Color(0xFF5B7A52),
    4096: Color(0xFF19295A), 
  },
  textColors: {
    2: Colors.white,
    4: Colors.white,
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.white,
    4096: Colors.white,
  },
  appBar: Color(0xFFBC0D11),
  gridColor: Color(0xFF008529),
  gridBackground: Color(0xFF226A5E),
  extraTile: Color(0xFF19295A),
  activeButton: Color(0xFFDD1539),
  inactiveButton: Color(0xFFD85564),
  lightText: Colors.white,
  darkText: Colors.black,
  actionButton: Color(0xFF0C6F30),
);