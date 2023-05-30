import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//모든 에러, 경고 관련 창
openAlertDialog({
  required String title,
  String? content,
  String? btnText,
  String? secondButtonText,
  VoidCallback? function,
}) {
  return Get.dialog(AlertDialog(
    title: Text(
      title,
    ),
    content: content == null
        ? null
        : Text(
            content,
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 15,
            ),
          ),
    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    actions: [
      TextButton(
        onPressed: function ??
            () {
              Get.back();
            },
        child: Text(
          btnText ?? "확인",
          style: TextStyle(
            fontSize: 15,
            color: CustomColors.mainPink,
          ),
        ),
      ),
      secondButtonText != null
          ? TextButton(
              onPressed: function ??
                  () {
                    Get.back();
                  },
              child: Text(
                secondButtonText,
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyText,
                ),
              ),
            )
          : Container(),
    ],
  ));
}
