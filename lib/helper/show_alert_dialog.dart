import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

//모든 에러, 경고 관련 창
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
            fontSize: 20,
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
