import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/list_completed_repository.dart';
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

  Future<DiaryModel> listCompleted() async {
    await ListCompletedRepository.setCompletedBukkungList(bukkungListModel);
    BukkungListPageController.to.deleteBukkungList(bukkungListModel, false);

    // DiaryModel diaryModel = DiaryModel.init(AuthController.to.user.value);
    // DiaryModel updatedDiaryModel = diaryModel.copyWith(
    //   title: bukkungListModel.title,
    //   category: bukkungListModel.category,
    //   location: bukkungListModel.location,
    //   date: bukkungListModel.date,
    //   updatedAt: DateTime.now(),
    // );

    var uuid = Uuid();
    DiaryModel completedListDiary = DiaryModel(
      diaryId: uuid.v1(),
      title: bukkungListModel.title,
      category: bukkungListModel.category,
      location: bukkungListModel.location,
      date: bukkungListModel.date,
      createdAt: DateTime.now(),
    );

    return completedListDiary;
  }
}
