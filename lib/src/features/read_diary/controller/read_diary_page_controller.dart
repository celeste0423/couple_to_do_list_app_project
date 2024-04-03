import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:get/get.dart';

class ReadDiaryPageController extends GetxController {
  RxInt activeIndex = 0.obs;
  final DiaryModel selectedDiaryModel = Get.arguments;
  RxInt? tabIndex;
  Rx<String?>? myNickname;
  Rx<String?>? buddyNickname;
  Rx<String?>? myComment;
  Rx<String?>? bukkungComment;

  void getSogam() {
    if (AuthController.to.user.value.uid == selectedDiaryModel.creatorUserID) {
      myComment = selectedDiaryModel.creatorSogam.obs;
      bukkungComment = selectedDiaryModel.bukkungSogam.obs;
    } else {
      bukkungComment = selectedDiaryModel.creatorSogam.obs;
      myComment = selectedDiaryModel.bukkungSogam.obs;
    }
  }

  Future<void> getNickname() async {
    if (AuthController.to.user.value.gender == 'male') {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.femaleUid!);
      myNickname = AuthController.to.user.value.nickname.obs;
      buddyNickname = buddyData!.nickname.obs;
    } else {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.maleUid!);
      myNickname = AuthController.to.user.value.nickname.obs;
      buddyNickname = buddyData!.nickname.obs;
    }
    print('짝꿍 닉네임 $buddyNickname');
  }

  Future<void> sendCompletedMessageToBuddy() async {
    final buddyUid = AuthController.to.user.value.gender == 'male'
        ? AuthController.to.group.value.femaleUid
        : AuthController.to.group.value.maleUid;
    print('짝꿍 uid $buddyUid');
    final userTokenData = await FCMController().getDeviceTokenByUid(buddyUid!);
    if (userTokenData != null) {
      print('유저 토큰 존재');
      FCMController().sendMessageController(
        userToken: userTokenData.deviceToken!,
        platform: userTokenData.platform,
        title: "${AuthController.to.user.value.nickname}님이 다이어리 소감 작성을 요청했어요!",
        body: '지금 바로 작성해보세요',
        dataType: 'diary',
        dataContent: selectedDiaryModel.diaryId,
      );
    }
  }

  @override
  void onInit() {
    tabIndex = 0.obs;
    getSogam();
    getNickname();
    super.onInit();
  }

  void setActiveIndex(int index) {
    activeIndex.value = index;
  }

  void setTabIndex(int index) {
    tabIndex!.value = index;
  }
}
