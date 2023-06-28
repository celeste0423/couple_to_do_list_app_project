import 'package:couple_to_do_list_app/features/setting/controller/notification_setting_page_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingPage
    extends GetView<NotificationSettingPageController> {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationSettingPageController());
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.mainPink,
          ),
        ),
        title: TitleText(
          text: '알림',
        ),
      ),
    );
  }
}
