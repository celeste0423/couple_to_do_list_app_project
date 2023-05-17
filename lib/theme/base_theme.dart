import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.backgroundLightGrey,
    //텍스트 기본 설정
    textTheme: TextTheme(
      labelLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      labelMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      labelSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      titleLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      titleMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      titleSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      headlineLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      headlineMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      headlineSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      displayLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      displayMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
      displaySmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'Yoonwoo',
        letterSpacing: 1.5,
      ),
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
        fontSize: 40,
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
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 20,
        fontFamily: 'YoonWoo',
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: CustomColors.mainPink,
      surfaceTintColor: Colors.yellow,
    ),
  );
}
