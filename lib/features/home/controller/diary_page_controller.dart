import 'package:get/get.dart';

class DiaryPageController extends GetxController {
  static DiaryPageController get to => Get.find();
  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "all": "전체",
    "1travel": "여행",
    "2meal": "식사",
    "3activity": "액티비티",
    "4culture": "문화 활동",
    "5study": "자기 계발",
    "6etc": "기타",
  };

  @override
  void onInit() {
    super.onInit();
    listCategory.value = "all";
    // myGroup(AuthController.to.group.value);
  }
//
//   Stream<List<DiaryModel>> getAllDiaryList(String type) {
//     // AuthController.to.saveGroupData();
//     final GroupModel groupModel = AuthController.to.group.value;
//     // final GroupModel groupModel = await AuthController.to.group.value;
//     print('현재 그룹 (buk page cont)${groupModel.uid}');
//     // print('현재 유저 (buk page cont)${myGroup.value.uid}');
//
//     switch (type) {
//       case 'category':
//         return BukkungListRepository(groupModel: groupModel)
//             .getAllBukkungListByDate();
//       case 'date':
//         return BukkungListRepository(groupModel: groupModel)
//             .getAllBukkungListByDate();
//       case 'like':
//         return BukkungListRepository(groupModel: groupModel)
//             .getAllBukkungListByDate();
//       default:
//         print('에러: 분류 타입 지정 안됨(buk cont)');
//         return BukkungListRepository(groupModel: groupModel)
//             .getAllBukkungListByDate();
//     }
//   }
// }
}
