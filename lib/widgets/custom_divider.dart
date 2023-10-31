import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

Widget customDivider() {
  return Padding(
    key: BukkungListPageController.to.bukkungListKey,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Divider(
      thickness: 2,
      color: CustomColors.mainPink,
    ),
  );
}
