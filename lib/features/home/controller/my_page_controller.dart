import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/group_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPageController extends GetxController {
  Rx<String> myNickname = ''.obs;
  Rx<String> buddyNickname = ''.obs;

  Rx<bool> isChangeNickname = false.obs;
  TextEditingController nicknameController = TextEditingController();

  Rx<bool> isDayMet = false.obs;
  Rx<int> togetherDate = 0.obs;

  Rx<int> bukkungListCount = 0.obs;
  Rx<int> viewCount = 0.obs;
  Rx<int> likeCount = 0.obs;
  Rx<int> expPoint = 0.obs;

  @override
  void onInit() {
    super.onInit();

    _getNickname();
    _getDayMet();
    _getAchievement();
  }

  void _getNickname() async {
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

  void _getDayMet() {
    if (AuthController.to.group.value.dayMet != null) {
      isDayMet(true);

      DateTime now = DateTime.now();
      DateTime dayMet = AuthController.to.group.value.dayMet!;
      Duration difference = now.difference(dayMet);
      int diffDays = difference.inDays;
      togetherDate(diffDays);
    }
  }

  void _getAchievement() async {
    // viewCount(0);
    // likeCount(0);
    // List<BukkungListModel> bukkungLists =
    //     await ListSuggestionRepository().getFutureMyBukkungList();
    //
    // for (BukkungListModel bukkunglist in bukkungLists) {
    //   viewCount.value += bukkunglist.viewCount!.toInt();
    //   likeCount.value += bukkunglist.likeCount!.toInt();
    // }
    // bukkungListCount(bukkungLists.length);
    // print('이게 점수야 ${AuthController.to.user.value.expPoint}');
    // if()
    // expPoint(AuthController.to.user.value.expPoint);

    List<int> listExpViewLikeCount = await AuthController().getExpPoint();
    expPoint(listExpViewLikeCount[0]);
    viewCount(listExpViewLikeCount[1]);
    likeCount(listExpViewLikeCount[2]);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void changeNicknameStart() {
    nicknameController.text = myNickname.value; //수정 기본값 세팅
    isChangeNickname(true);
  }

  void changeNickname() {
    UserModel updatedData = AuthController.to.user.value.copyWith(
      nickname: nicknameController.text,
    );
    AuthController.to.user(updatedData);
    UserRepository.updateNickname(nicknameController.text);
    _getNickname();
    isChangeNickname(false);
  }

  void setDayMet(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      helpText: '처음 만난 날짜를 선택하세요',
      initialDate: AuthController.to.group.value.dayMet ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('ko', ''),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: CustomColors.mainPink,
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      // AuthController의 group 값 업데이트
      GroupModel updatedData = AuthController.to.group.value.copyWith(
        dayMet: selectedDate,
      );
      AuthController.to.group(updatedData);
      //파이어베이스 값 업데이트
      GroupRepository.updateGroupDayMet(selectedDate);
    }
    _getDayMet();
  }

  void refreshAchievement() {
    _getAchievement();
  }

  Future<void> openChatUrl() async {
    Uri uri = Uri.parse(Constants.kakaoQuestionChat);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      openAlertDialog(title: '오류 발생');
    }
  }
}
