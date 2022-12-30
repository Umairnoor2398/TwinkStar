import 'package:flutter/material.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';
import 'package:twinkstar/utils/colors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    backgroundColor: Coloors.darkBackground,
    scaffoldBackgroundColor: Coloors.darkBackground,
    extensions: [
      CustomThemeExtension.darkMode,
    ],
    // colorScheme: const ColorScheme.dark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Coloors.darkButtonColor,
      foregroundColor: Coloors.darkTextColor,
      splashFactory: NoSplash.splashFactory,
      elevation: 0,
      shadowColor: Colors.transparent,
    )),
    appBarTheme: const AppBarTheme(
      color: Coloors.darkAppBar,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Coloors.darkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    ),
  );
}
