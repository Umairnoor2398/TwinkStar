import 'package:flutter/material.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';
import 'package:twinkstar/utils/colors.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: Coloors.lightBackground,
    scaffoldBackgroundColor: Coloors.lightBackground,
    extensions: [
      CustomThemeExtension.lightMode,
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Coloors.lightButtonColor,
      foregroundColor: Coloors.lightBackground,
      splashFactory: NoSplash.splashFactory,
      elevation: 0,
      shadowColor: Colors.transparent,
    )),
    appBarTheme: const AppBarTheme(
      color: Coloors.lightAppBar,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
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
