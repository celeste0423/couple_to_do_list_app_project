import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.backgroundLightGrey,
    brightness: Brightness.light,
    //텍스트 기본 설정
    textTheme: TextTheme(
      labelLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      labelMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      labelSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      titleLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      titleMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      titleSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      headlineLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      headlineMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      headlineSmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      displayLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      displayMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      displaySmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      bodySmall: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      bodyLarge: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
      bodyMedium: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
        fontFamily: 'nanum',
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.backgroundLightGrey,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 20,
        fontFamily: 'nanum',
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
          borderRadius: BorderRadius.circular(15.0),
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
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          width: 15,
          color: CustomColors.backgroundLightGrey,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 15,
        fontFamily: 'Nanum',
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: CustomColors.mainPink,
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(CustomColors.mainPink),
      trackColor: MaterialStatePropertyAll(CustomColors.lightGrey),
    ),
    textSelectionTheme: base.textSelectionTheme.copyWith(
      cursorColor: CustomColors.mainPink,
      selectionHandleColor: CustomColors.mainPink,
      selectionColor: CustomColors.mainPink,
    ),
    canvasColor: Color.fromRGBO(10, 10, 10, 1),
  );
}
