import 'package:couple_to_do_list_app/features/home/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:get/get.dart';

class BukkungListController extends GetxController {
  static BukkungListController get to => Get.find();
  Rx<BukkungListModel> bukkungList = BukkungListModel().obs;

  Stream<List<BukkungListModel>> getAllBukkungList(
      String type, GroupModel groupModel) {
    switch (type) {
      case 'date':
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();

      default:
        print('에러: 분류 타입 지정 안됨');
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();
    }
  }
}
