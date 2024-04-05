import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:couple_to_do_list_app/src/utils/group_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FindBuddyPageController extends GetxController {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    myDataStream();
  }

  void myDataStream() {
    Stream<UserModel?> myDataStream =
        UserRepository.getUserStream(AuthController.to.user.value.uid!);
    myDataStream.listen((myData) {
      // print('데이터 변함 ${myData!.groupId}');
      if (myData!.groupId != null &&
          !GroupUtil().isSoloGroup(myData!.groupId)) {
        openAlertDialog(title: '짝꿍을 찾았습니다!', content: '짝꿍 추가가 완료되었습니다.');
        AuthController.to.setUserData(myData);
      }
    });
  }

  void soloGroupButton(String email) async {
    if (AuthController.to.group.value.uid == null) {
      await AuthController.to.soloGroupCreation(email);
    }
  }

  void startButton(String email) async {
    GroupIdStatus groupIdStatus = await AuthController.to.groupCreation(
      email,
      emailController.text,
    );
    if (groupIdStatus == GroupIdStatus.noData) {
      openAlertDialog(title: '올바른 메일주소를 입력하였는지,\n짝꿍이 회원가입을 완료 하였는지 확인해주세요.');
    } else if (groupIdStatus == GroupIdStatus.hasGroup) {
      openAlertDialog(title: '상대방이 이미 짝꿍이 있습니다.\n올바른 메일주소를 입력하였는지 확인해주세요.');
    }
  }
}
