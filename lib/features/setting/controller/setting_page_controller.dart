import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageController extends GetxController {
  static SettingPageController get to => Get.find();
  Rx<String> loginType = ''.obs;

  final Uri _url = Uri.parse(Constants.noticeNotionUrl);

  @override
  void onInit() {
    super.onInit();
    _getLoginType();
  }

  Future<void> _getLoginType() async {
    loginType.value = await UserRepository.getLoginType();
  }

  Future<void> openNotice() async {
    try {
      launchUrl(_url);
    } catch (e) {
      openAlertDialog(title: e.toString());
    }
  }

  Future signOut() async {
    return await UserRepository.signOut();
  }
}
