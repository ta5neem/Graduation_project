import 'package:gui/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: ColorsManager.darkTeal,
      shadowColor: ColorsManager.lightGrey.withOpacity(0.3),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black87,
          shadowColor: Colors.white),
      fontFamily: "Comfortaa",
    );
  }
}
