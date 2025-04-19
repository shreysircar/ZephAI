import 'package:flutter/material.dart';

class FontSizes {
  static const extraSmall = 14.0;
  static const small = 16.0;
  static const standard = 18.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const doubltExtraLarge = 26.0;
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xffffffff),
    primary:  Color.fromARGB(255, 141, 8, 250),
    secondary: Color(0xffffffff),
  ),
  textTheme: TextTheme(
    titleSmall: TextStyle(color: Color(0xff000000)), // Black text in light mode
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xff000000),
    primary:  Color.fromARGB(255, 141, 8, 250),
    secondary: Color(0xffffffff),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0xffffffff)),
    titleSmall: TextStyle(color: Colors.black),  // Ensure typed text is black
  ),
);
