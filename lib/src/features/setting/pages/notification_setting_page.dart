import 'package:couple_to_do_list_app/src/features/setting/controller/notification_setting_page_controller.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingPage
    extends GetView<NotificationSettingPageController> {
  const NotificationSettingPage({Key? key}) : super(key: key);

  Widget _settingListTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '버꿍리스트 공개 여부 설정',
                style: TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 15,
                ),
              ),
              Obx(() {
                return Switch(
                  inactiveThumbColor: CustomColors.grey,
                  value: controller.notificationEnabled.value,
                  onChanged: (value) {
                    controller.notificationEnabled.value = value;
                    controller.toggleNotificationSettings(value);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

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
      body: _settingListTile(),
    );
  }
}
