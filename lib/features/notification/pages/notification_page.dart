import 'package:couple_to_do_list_app/features/notification/controllers/notification_page_controller.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      title: TitleText(
        text: '알림',
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(2.0), // 하단 선의 높이 조절
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomDivider(),
        ),
      ),
    );
  }

  Widget _notificationList(BuildContext context) {
    return GetBuilder<NotificationPageController>(
      id: 'notificationBuilder',
      builder: (NotificationPageController controller) {
        return controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: CustomColors.mainPink,
                ),
              )
            : controller.notifications.length == 0
                ? Center(
                    child: Text(
                      '아직 알림이 없습니다.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GroupedListView<NotificationModel, String>(
                      elements: controller.notifications,
                      groupBy: (notification) {
                        return DateFormat('yyyy-MM-dd')
                            .format(notification.createdAt);
                      },
                      groupSeparatorBuilder: (String date) {
                        return _notificationSeperator(date);
                      },
                      itemBuilder: (context, NotificationModel notification) {
                        return _notificationCard(notification);
                      },
                    ),
                  );
      },
    );
  }

  Widget _notificationSeperator(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _notificationCard(NotificationModel notification) {
    String difference = timeago.format(notification.createdAt, locale: 'ko');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          controller.updateIsChecked(notification.notificationId);
          controller.openPage(notification);
        },
        child: Stack(
          children: [
            Opacity(
              opacity: notification.isChecked ? 0.4 : 1,
              child: Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                        backgroundColor: CustomColors.mainPink,
                        radius: 21,
                        foregroundImage:
                            AssetImage('assets/images/baseimage_ggomool.png'),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              notification.title!,
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.blackText,
                              ),
                            ),
                          ),
                          Text(
                            notification.content!,
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.greyText,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            difference,
                            style: TextStyle(
                              fontSize: 10,
                              color: CustomColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.deleteNotification(notification.notificationId);
                },
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: CustomColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationPageController());
    return Scaffold(
      appBar: _appBar(),
      body: _notificationList(context),
    );
  }
}
