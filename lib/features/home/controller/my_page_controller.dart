import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  Rx<String> myNickname = ''.obs;
  Rx<String> buddyNickname = ''.obs;

  @override
  void onInit() {
    super.onInit();

    getNickname();
  }

  void getNickname() async {
    if (AuthController.to.user.value.gender == 'male') {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.femaleUid!);
      myNickname(AuthController.to.user.value.nickname);
      buddyNickname(buddyData!.nickname);
    } else {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.maleUid!);
      myNickname(AuthController.to.user.value.nickname);
      buddyNickname(buddyData!.nickname);
    }
  }
}
