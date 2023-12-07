import 'package:couple_to_do_list_app/features/notification/controllers/notification_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends GetView<NotificationPageController> {
  const NotificationPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image(image: AssetImage('assets/images/title_horizontal.png')),
      ),
      leadingWidth: 190,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.notifications,
              color: CustomColors.lightGrey,
              size: 30,
            ),
          ),
        )
      ],
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
