import 'package:flutter/material.dart';
import 'package:twinkstar/utils/colors.dart';

extension ExtendedTheme on BuildContext {
  CustomThemeExtension get theme =>
      Theme.of(this).extension<CustomThemeExtension>()!;
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  static CustomThemeExtension lightMode = CustomThemeExtension(
    borderColor: Coloors.lightBorder,
    backgroundColor: Coloors.lightBackground,
    textColor: Coloors.lightTextColor,
    textFieldColor: Colors.black,
    drawerColor: Coloors.lightDrawerBackground,
    liquidRefresh: Colors.blue,
    bottomSheetColor: Colors.blue,
    bottomSheetColor2: Colors.white,
  );

  static CustomThemeExtension darkMode = CustomThemeExtension(
    borderColor: Coloors.darkBorder,
    backgroundColor: Coloors.darkBackground,
    textColor: Coloors.darkTextColor,
    textFieldColor: Colors.black,
    drawerColor: Coloors.darkDrawerBackground,
    liquidRefresh: Colors.black,
    bottomSheetColor: Coloors.darkBackground,
    bottomSheetColor2: Coloors.darkBackground,
  );

  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? textFieldColor;
  final Color? drawerColor;
  final Color? liquidRefresh;
  final Color? bottomSheetColor;
  final Color? bottomSheetColor2;

  CustomThemeExtension({
    this.bottomSheetColor,
    this.bottomSheetColor2,
    this.liquidRefresh,
    this.drawerColor,
    this.textFieldColor,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });
  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? borderColor,
    Color? backgroundColor,
    Color? textColor,
    Color? textFieldColor,
    Color? drawerColor,
    Color? liquidRefresh,
    Color? bottomSheetColor,
    Color? bottomSheetColor2,
  }) {
    return CustomThemeExtension(
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textFieldColor: textFieldColor ?? this.textFieldColor,
      drawerColor: drawerColor ?? this.drawerColor,
      liquidRefresh: liquidRefresh ?? this.liquidRefresh,
      bottomSheetColor: bottomSheetColor ?? this.bottomSheetColor,
      bottomSheetColor2: bottomSheetColor2 ?? this.bottomSheetColor2,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      textFieldColor: Color.lerp(textFieldColor, other.textFieldColor, t),
      drawerColor: Color.lerp(drawerColor, other.drawerColor, t),
      liquidRefresh: Color.lerp(liquidRefresh, other.liquidRefresh, t),
      bottomSheetColor: Color.lerp(bottomSheetColor, other.bottomSheetColor, t),
      bottomSheetColor2:
          Color.lerp(bottomSheetColor2, other.bottomSheetColor2, t),
    );
  }
}
