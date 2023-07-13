import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/list_completed_repository.dart';
import 'package:get/get.dart';

class GgomulPageController extends GetxController {
  Rx<int> completedListCount = 0.obs;

  @override
  onInit() async {
    super.onInit();
    completedListCount.value = await _updateCompletedListCount();
  }

  Future<int> _updateCompletedListCount() async {
    //딜레이 1초 -> 애니메이션
    await Future.delayed(Duration(milliseconds: 500));
    List<BukkungListModel> data =
        await ListCompletedRepository().getFutureCompletedBukkungListByDate();
    return data.length;
  }

  @override
  onClose() {
    super.onClose();
  }

  Stream<List<BukkungListModel>> getAllCompletedList() {
    return ListCompletedRepository().getCompletedBukkungListByDate();
  }

  //Todo:리스트 삭제 기능을 제공해..? 말아?
  void deleteCompletedList(BukkungListModel bukkungListModel) async {
    if (Constants.baseImageUrl != bukkungListModel.imgUrl) {
      await BukkungListRepository.deleteImage(bukkungListModel.imgUrl!);
    }
    await ListCompletedRepository().deleteCompletedList(bukkungListModel);
  }
}
