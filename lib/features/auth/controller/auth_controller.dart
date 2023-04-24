import 'package:couple_to_do_list_app/features/auth/pages/find_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/user_registration_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/wait_buddy_page.dart';
import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var registerProgressIndex = 'welcome'.obs;
  //정보를 다 입력한 후 짝꿍을 기다리다가 앱을 나갔을 경우 대비

  void changeRegisterProgressIndex(String step) {
    registerProgressIndex.value = step;

    switch (registerProgressIndex.value) {
      case 'welcome':
        Get.to(() => WelcomePage());
        break;
      case 'userRegistration':
        Get.to(() => UserRegistrationPage());
        break;
      case 'findBuddy':
        Get.to(() => FindBuddyPage());
        break;
      case 'waitBuddy':
        Get.to(() => WaitBuddyPage());
        break;

      default:
        Get.to(() => WelcomePage());
    }
  }
}
