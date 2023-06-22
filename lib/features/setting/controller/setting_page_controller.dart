import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:get/get.dart';

class SettingPageController extends GetxController {
  Future signOut() async {
    return await UserRepository.signOut();
  }
}
