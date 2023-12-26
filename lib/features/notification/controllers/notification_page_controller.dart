import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';
import 'package:couple_to_do_list_app/repository/notification_repository.dart';
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
    isLoading = false;
    update(['notificationBuilder'], true);
  }

  void updateIsChecked(String notificationId) async {
    await NotificationRepository().updateIsChecked(notificationId);
  }

  void openPage(NotificationModel notification) {
    //페이지 이동 만들기, 타입하고 contentId에 따라, 현재 페이지는 종료하고
  }
}
