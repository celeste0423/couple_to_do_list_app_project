import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/user_registration_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/wait_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var registerProgressIndex = 0.obs;
  //정보를 다 입력한 후 짝꿍을 기다리다가 앱을 나갔을 경우 대비

  void changeRegisterProgressIndex(int index) {
    registerProgressIndex.value = index;

    switch (registerProgressIndex.value) {
      case 0:
        Get.to(() => WelcomePage());
        break;
      case 1:
        Get.to(() => UserRegistrationPage());
        break;
      case 2:
        Get.to(() => FindBuddyPage());
        break;
      case 3:
        Get.to(() => WaitBuddyPage());
        break;

      default:
        Get.to(() => WelcomePage());
    }
  }
}
