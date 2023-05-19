import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:get/get.dart';

class BukkungListPageController extends GetxController {
  static BukkungListPageController get to => Get.find();
  // Rx<GroupModel> myGroup = GroupModel().obs;
  Rx<BukkungListModel> bukkungList = BukkungListModel().obs;

  Rx<String?> currentType = "category".obs;
  Map<String, String> typetoString = {
    "category": "카테고리 별",
    "date": "날짜 순",
    "like": "좋아요 순",
  };

  @override
  void onInit() {
    super.onInit();
    currentType.value = "category";
    // myGroup(AuthController.to.group.value);
  }

  Stream<List<BukkungListModel>> getAllBukkungList(String type) {
    // AuthController.to.saveGroupData();
    final GroupModel groupModel = AuthController.to.group.value;
    // final GroupModel groupModel = await AuthController.to.group.value;
    print('현재 그룹 (buk page cont)${groupModel.uid}');
    // print('현재 유저 (buk page cont)${myGroup.value.uid}');

    switch (type) {
      case 'category':
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();
      case 'date':
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();
      case 'like':
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();
      default:
        print('에러: 분류 타입 지정 안됨(buk cont)');
        return BukkungListRepository(groupModel: groupModel)
            .getAllBukkungListByDate();
    }
  }
}
