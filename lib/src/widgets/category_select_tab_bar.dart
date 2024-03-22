import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:flutter/material.dart';

class CategorySelectTabBar extends StatelessWidget {
  TabController tabController;
  Color? selectedColor;
  Color? unselectedColor;
  bool? isMyTab;

  CategorySelectTabBar({
    Key? key,
    required this.tabController,
    this.selectedColor,
    this.unselectedColor,
    this.isMyTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      labelColor: selectedColor ?? CustomColors.darkGrey,
      labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
      unselectedLabelColor:
          unselectedColor ?? CustomColors.grey.withOpacity(0.5),
      indicator: UnderlineTabIndicator(
          insets: EdgeInsets.only(left: 20, right: 20, bottom: 5),
          borderSide: BorderSide(
            width: 3,
            color: selectedColor ?? CustomColors.darkGrey,
          )),
      tabs: [
        Tab(text: '전체'),
        Tab(text: '여행'),
        Tab(text: '식사'),
        Tab(text: '액티비티'),
        Tab(text: '문화활동'),
        Tab(text: '자기계발'),
        Tab(text: '기타'),
        if (isMyTab != null) Tab(text: '내 리스트'),
      ],
    );
  }
}
