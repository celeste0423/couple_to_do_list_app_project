import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/src/helper/analytics.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/repository/bukkunglist_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ReadBukkungListPageController extends GetxController {
  final BukkungListModel bukkungListModel = Get.arguments;

  final Rx<String> imgUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    imgUrl(bukkungListModel.imgUrl);
  }

  Future<DiaryModel> createDiary() async {
    // await ListCompletedRepository.setCompletedBukkungList(bukkungListModel);
    // BukkungListPageController.to.deleteBukkungList(bukkungListModel, false);
    var uuid = Uuid();
    DiaryModel completedListDiary = DiaryModel(
      diaryId: uuid.v1(),
      title: bukkungListModel.title,
      category: bukkungListModel.category,
      location: bukkungListModel.location,
      imgUrlList: null,
      creatorSogam: null,
      bukkungSogam: null,
      date: bukkungListModel.date,
      creatorUserID: AuthController.to.user.value.uid,
      createdAt: DateTime.now(),
      lastUpdatorID: null,
      updatedAt: null,
    );

    return completedListDiary;
  }

  void listCompletedButton() async {
    if (bukkungListModel.isCompleted == null ||
        !bukkungListModel.isCompleted!) {
      BukkungListModel completedBukkungListModel = bukkungListModel.copyWith(
        isCompleted: true,
      );
      BukkungListRepository().updateGroupBukkungList(completedBukkungListModel);
      openAlertDialog(
        title: '다이어리를 작성하시겠어요?',
        content: '완료한 버꿍리스트에 대해 다이어리를 작성해보세요!',
        btnText: '네',
        secondButtonText: '아니요',
        secondfunction: () {
          Get.back(); //dialog back
          Get.back();
        },
        mainfunction: () async {
          DiaryModel updatedDiaryModel = await createDiary();
          Get.back(); //다이알로그 꺼지고,
          Get.off(() => UploadDiaryPage(), arguments: updatedDiaryModel);
          Analytics().logEvent('group_bukkunglist_completed', null);
          Analytics().logEvent('diary_created_afterCompletion', null);
        },
      );
    } else {
      openAlertDialog(
        title: '버꿍리스트 완료를 취소하시겠어요?',
        content: '다시 완료한 이전 상태로 돌아갑니다',
        btnText: '네',
        secondButtonText: '아니요',
        secondfunction: () {
          Get.back(); //dialog back
          Get.back();
        },
        mainfunction: () async {
          BukkungListModel completedBukkungListModel =
              bukkungListModel.copyWith(
            isCompleted: false,
          );
          BukkungListRepository()
              .updateGroupBukkungList(completedBukkungListModel);
          Get.back(); //다이알로그 꺼지고,
          Get.back();
        },
      );
    }
  }
}
