import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:get/get.dart';

class ReadDiaryPageController extends GetxController {
  final DiaryModel selectedDiaryModel = Get.arguments;

  Rx<int> activeIndex = 0.obs;
  // int? tabIndex;
  Rx<bool> isMyComment = true.obs;

  Rx<String> myNickname = ''.obs;
  Rx<String> buddyNickname = ''.obs;

  String? myComment;
  String? buddyComment;

  @override
  void onInit() async {
    getComment();
    await getNickname();
    super.onInit();
  }

  void getComment() {
    if (AuthController.to.user.value.uid == selectedDiaryModel.creatorUserID) {
      myComment = selectedDiaryModel.creatorSogam;
      buddyComment = selectedDiaryModel.bukkungSogam;
    } else {
      buddyComment = selectedDiaryModel.creatorSogam;
      myComment = selectedDiaryModel.bukkungSogam;
    }
  }

  Future<void> getNickname() async {
    if (AuthController.to.user.value.gender == 'male') {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.femaleUid!);
      myNickname.value = AuthController.to.user.value.nickname!;
      buddyNickname.value = buddyData!.nickname!;
    } else {
      UserModel? buddyData = await UserRepository.getUserDataByUid(
          AuthController.to.group.value.maleUid!);
      myNickname.value = AuthController.to.user.value.nickname!;
      buddyNickname.value = buddyData!.nickname!;
    }
    print('짝꿍 닉네임 $buddyNickname');
  }
  //init

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

  void setActiveIndex(int index) {
    activeIndex(index);
  }

  void tabViewButton() {
    isMyComment(!isMyComment.value);
  }
}
