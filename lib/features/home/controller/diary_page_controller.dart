import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryPageController extends GetxController with GetTickerProviderStateMixin{
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

  RxList<DiaryModel> diarylist = <DiaryModel>[].obs;
  Rx<DiaryModel?> selectedDiary = DiaryModel().obs;

  Rx<String> femaleNickname =''.obs;
  Rx<String> maleNickname = ''.obs;
  late final TabController tabDiaryController =
  TabController(length: 7, vsync: this);

  @override
  void onInit() async{
    super.onInit();
    listCategory.value = "all";
    diarylist.bindStream(getDiaryList('all'));
    getNickname();

  }

  initSelectedDiary(){
    selectedDiary(diarylist[0]);
  }

  getNickname()async{
    final String femaleUid = AuthController.to.group.value.femaleUid!;
    final String maleUid = AuthController.to.group.value.maleUid!;
    final maledata =await FirebaseFirestore.instance.collection('users').doc(maleUid).get();
    final femaledata =await FirebaseFirestore.instance.collection('users').doc(femaleUid).get();
    maleNickname(maledata.data()!['nickname'].toString());
    femaleNickname(femaledata.data()!['nickname'].toString());
  }

  Stream<List<DiaryModel>> getDiaryList(String type) {
    // AuthController.to.saveGroupData();
    final GroupModel groupModel = AuthController.to.group.value;
    // final GroupModel groupModel = await AuthController.to.group.value;
    print('현재 그룹 (buk page cont)${groupModel.uid}');
    // print('현재 유저 (buk page cont)${myGroup.value.uid}');

    return DiaryRepository(groupModel: groupModel)
        .getallDiary();

  }

  @override
  void onClose() {
    tabDiaryController.dispose();
    super.onClose();
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
