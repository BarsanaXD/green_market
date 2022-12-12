import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
      //0A1931  // white yellow 0xFFFCF8EC
      isDarkTheme ? const Color(0xFF151515) : const Color(0xFFe4e6eb),
      primaryColor: const Color(0xff4e9d18) ,
      colorScheme: ThemeData().colorScheme.copyWith(
        secondary:
        isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      cardColor:
      isDarkTheme ? const Color(0xFF292929) : Color(0xffffffff),
      canvasColor: isDarkTheme ? Color(0xff000000) : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}