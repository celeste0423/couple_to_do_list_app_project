import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, this.padding}) : super(key: key);
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: CustomColors.mainPink,
    );
  }
}
