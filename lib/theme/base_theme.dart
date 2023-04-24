import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData(fontFamily: 'Yoonwoo');
  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.backgroundLightGrey,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.mainPink,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 35, fontFamily: 'Yoonwoo'),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.5),
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: CustomColors.backgroundLightGrey,
      onPrimary: CustomColors.backgroundLightGrey,
      secondary: CustomColors.backgroundLightGrey,
      onSecondary: CustomColors.backgroundLightGrey,
      error: CustomColors.backgroundLightGrey,
      onError: CustomColors.backgroundLightGrey,
      background: CustomColors.backgroundLightGrey,
      onBackground: CustomColors.backgroundLightGrey,
      surface: CustomColors.backgroundLightGrey,
      onSurface: CustomColors.backgroundLightGrey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: CustomColors.mainPink,
        foregroundColor: CustomColors.lightPink,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    iconTheme: IconThemeData(
      size: 40,
    ),
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.backgroundLightGrey,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );
}
