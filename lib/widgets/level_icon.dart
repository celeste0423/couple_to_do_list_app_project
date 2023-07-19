import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class LevelIcon extends StatelessWidget {
  final int level;
  final double? size;

  const LevelIcon({
    Key? key,
    required this.level,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 15,
      height: size ?? 15,
      decoration: BoxDecoration(
        color: level < 2
            ? CustomColors.level1.withOpacity(0.7)
            : level < 4
                ? CustomColors.level2.withOpacity(0.7)
                : level < 6
                    ? CustomColors.level3.withOpacity(0.7)
                    : CustomColors.level4.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
