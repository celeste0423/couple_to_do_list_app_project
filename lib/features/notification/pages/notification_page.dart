import 'package:couple_to_do_list_app/features/notification/controllers/notification_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends GetView<NotificationPageController> {
  const NotificationPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CupertinoButton(
          onPressed: () {
            Get.back();
          },
          padding: const EdgeInsets.all(0),
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: CustomColors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [],
      ),
    );
  }
}
