import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String category;
  final double? size;
  const CategoryIcon({Key? key, required this.category, this.size})
      : super(key: key);

  Widget _categoryIcon(Color color, String icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: size ?? 35,
      height: size ?? 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Image.asset(
        'assets/icons/$icon.png',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case '1travel':
        return _categoryIcon(CustomColors.travel, 'airplane');
      case '3activity':
        return _categoryIcon(CustomColors.activity, 'running');
      case '5study':
        return _categoryIcon(CustomColors.study, 'study');
      case '2meal':
        return _categoryIcon(CustomColors.meal, 'food');
      case '4culture':
        return _categoryIcon(CustomColors.culture, 'singer');
      case '6etc':
        return _categoryIcon(CustomColors.etc, 'filter-file');
      default:
        return Container();
    }
  }
}
