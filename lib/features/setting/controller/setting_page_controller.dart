import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageController extends GetxController {
  final Uri _url = Uri.parse(Constants.noticeNotionUrl);

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
