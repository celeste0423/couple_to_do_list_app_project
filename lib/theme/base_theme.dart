import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.backgroundLightGrey,
    textTheme: TextTheme(
      bodySmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      bodyLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      bodyMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.backgroundLightGrey,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 35,
        fontFamily: 'Yoonwoo',
        letterSpacing: 2,
      ),
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
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.5),
      indicator: UnderlineTabIndicator(
        insets: EdgeInsets.only(top: 50, left: 39, right: 39),
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          width: 15,
          color: CustomColors.backgroundLightGrey,
        ),
      ),
    ),
  );
}
