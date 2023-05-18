import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._();

  //앱 대표 색
  static const Color mainPink = Color(0xFFF69696);

  // 원래 light pink :
  // static const Color lightPink = Color(0xFFFCD1D1);

  // lightpink 쫌 진하게 바꿨는데 맘에 안들면 말해~
  static const Color lightPink = Color(0xFFFABDBD);
  static const Color backgroundLightGrey = Color(0xFFEFEFEF);
  static const Color lightGrey = Color(0xFFBBBBBB);
  static const Color grey = Color(0xFF7A7A7A);
  static const Color darkGrey = Color(0xFF707070);
  static Color black = Color(0xFF000000).withOpacity(0.7);
  static const Color redbrown = Color(0xFF544141);

  //텍스트 컬러
  static const Color lightGreyText = Color(0xFF9B9B9B);
  static const Color greyText = Color(0xFF9F9F9F);
  static const Color blackText = Color(0xFF3B3B3B);

  //카테고리 색
  static const Color travel = Color(0xFFADE0E0);
  static const Color meal = Color(0xFFACDDBD);
  static const Color activity = Color(0xFFE2C2BF);
  static const Color culture = Color(0xFFD7DA72);
  static const Color study = Color(0xFF859EC9);
  static const Color etc = Color(0xFFE1CDAE);
}
