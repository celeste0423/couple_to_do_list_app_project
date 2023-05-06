import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//모든 에러, 경고 관련 창
openAlertDialog({required String message, String? btnText}) {
  return Get.dialog(AlertDialog(
    content: Text(
      message,
      style: TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: Text(
          btnText ?? "확인",
          style: TextStyle(
            fontSize: 15,
            color: CustomColors.mainPink,
          ),
        ),
      ),
    ],
  ));
}

showAlertDialog({
  required BuildContext context,
  required String message,
  String? btnText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: TextStyle(
            color: CustomColors.darkGrey,
            fontSize: 15,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              btnText ?? "확인",
              style: TextStyle(
                fontSize: 15,
                color: CustomColors.mainPink,
              ),
            ),
          ),
        ],
      );
    },
  );
}


