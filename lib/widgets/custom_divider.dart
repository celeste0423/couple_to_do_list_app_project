import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget customDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Divider(
      thickness: 2,
      color: CustomColors.mainPink,
    ),
  );
}
