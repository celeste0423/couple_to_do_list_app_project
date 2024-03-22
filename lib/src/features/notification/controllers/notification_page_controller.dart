import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/read_bukkung_list/pages/read_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/src/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/src/features/read_suggestion_list/pages/read_suggestion_list_page.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/models/notification_model.dart';
import 'package:couple_to_do_list_app/src/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/src/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/src/repository/notification_repository.dart';
import 'package:couple_to_do_list_app/src/repository/suggestion_list_repository.dart';
import 'package:get/get.dart';

class NotificationPageController extends GetxController {
  static NotificationPageController get to => Get.find();

  late List<NotificationModel> notifications;
  bool isLoading = true;

  @override
  void onInit() {
    _getAllNotification();
    super.onInit();
  }

  void _getAllNotification() async {
    isLoading = true;
    notifications = await NotificationRepository().getAllNotifications(
      AuthController.to.user.value.uid!,
    );
    //30일 지난 알림 삭제
    for (NotificationModel notification in notifications) {
      DateTime currentDate = DateTime.now();
      DateTime thirtyDaysAgo = currentDate.subtract(Duration(days: 30));
      if (notification.createdAt.isBefore(thirtyDaysAgo)) {
        deleteNotification(notification.notificationId);
      }
    }
    isLoading = false;
    update(['notificationBuilder'], true);
  }

  Future deleteNotification(String notificationId) async {
    await NotificationRepository()
        .deleteNotification(AuthController.to.user.value.uid!, notificationId);
    update(['notificationBuilder'], true);
  }

  void updateIsChecked(String notificationId) async {
    await NotificationRepository().updateIsChecked(notificationId);
  }

  void openPage(NotificationModel notification) async {
    switch (notification.type) {
      case 'diary':
        DiaryModel? sendedDiary =
            await DiaryRepository().getDiary(notification.contentId!);
        Get.off(() => ReadDiaryPage(), arguments: sendedDiary);
        break;
      case 'bukkunglist':
        BukkungListModel? sendedBukkungList = await BukkungListRepository()
            .getBukkungList(notification.contentId!);
        Get.off(() => ReadBukkungListPage(), arguments: sendedBukkungList);
        break;
      case 'comment':
        BukkungListModel? sendedBukkungList = await SuggestionListRepository()
            .getSuggestionListById(notification.contentId!);
        Get.off(() => ReadSuggestionListPage(), arguments: sendedBukkungList);
        break;
      default:
        openAlertDialog(title: '알림을 열 수 없습니다.');
    }
  }
}
