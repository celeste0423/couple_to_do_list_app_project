import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget categorySelectTabBar(
  TabController tabController,
  Color? selectedColor,
  Color? unselectedColor,
) {
  return TabBar(
    isScrollable: true,
    controller: tabController,
    labelColor: selectedColor ?? CustomColors.darkGrey,
    labelStyle: TextStyle(fontFamily: 'YoonWoo', fontSize: 20),
    unselectedLabelColor: unselectedColor ?? CustomColors.grey.withOpacity(0.5),
    indicator: UnderlineTabIndicator(
        insets: EdgeInsets.only(left: 20, right: 20, bottom: 5),
        borderSide: BorderSide(
          width: 3,
          color: selectedColor ?? CustomColors.darkGrey,
        )),
    tabs: const [
      Tab(text: '전체'),
      Tab(text: '여행'),
      Tab(text: '액티비티'),
      Tab(text: '식사'),
      Tab(text: '문화활동'),
      Tab(text: '기타'),
    ],
  );
}
