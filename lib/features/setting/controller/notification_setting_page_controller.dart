import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingPageController extends GetxController {
  Rx<bool> notificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notificationEnabled') == null) {
      prefs.setBool('notificationEnabled', true);
    }
    notificationEnabled(prefs.getBool('notificationEnabled'));
  }

  void toggleNotificationSettings(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationEnabled', enabled);
    print(prefs.getBool('notificationEnabled'));
  }
}
