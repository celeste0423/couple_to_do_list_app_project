import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryPageController extends GetxController
    with GetTickerProviderStateMixin {
  static DiaryPageController get to => Get.find();

  // ScrollController sliverScrollController = ScrollController();
  // Rx<bool> isScrollMax = false.obs;

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

  List<RxList<DiaryModel>> diaryList = [
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
    <DiaryModel>[].obs,
  ];
  Rx<DiaryModel> selectedDiary = DiaryModel().obs;

  Rx<String> femaleNickname = ''.obs;
  Rx<String> maleNickname = ''.obs;

  late final TabController diaryTabController =
      TabController(length: 7, vsync: this);

  @override
  void onInit() async {
    super.onInit();

    listCategory.value = "all";
    setDiaryList();
    initSelectedDiary();
    getNickname();
  }

  Future setDiaryList() async {
    print('다이어리 Future(dia cont)');
    diaryList[0].bindStream(getDiaryList('all'));
    diaryList[1].bindStream(getDiaryList('1travel'));
    diaryList[2].bindStream(getDiaryList('2meal'));
    diaryList[3].bindStream(getDiaryList('3activity'));
    diaryList[4].bindStream(getDiaryList('4culture'));
    diaryList[5].bindStream(getDiaryList('5study'));
    diaryList[6].bindStream(getDiaryList('6etc'));
  }

  Stream<List<DiaryModel>> getDiaryList(String category) {
    if (category == 'all') {
      return DiaryRepository().getAllDiary();
    } else {
      return DiaryRepository().getCategoryDiary(category);
    }
  }

  void initSelectedDiary() {
    final stream = getDiaryList('all');
    StreamSubscription<List<DiaryModel>>? subscription;
    subscription = stream.listen((diary) {
      if (diary.isNotEmpty) {
        final updatedDiary = selectedDiary.value!.copyWith(
          diaryId: diary[0].diaryId,
          title: diary[0].title,
          category: diary[0].category,
          location: diary[0].location,
          imgUrlList: diary[0].imgUrlList,
          creatorSogam: diary[0].creatorSogam,
          bukkungSogam: diary[0].bukkungSogam,
          date: diary[0].date,
          creatorUserID: diary[0].creatorUserID,
          createdAt: diary[0].createdAt,
          lastUpdatorID: diary[0].lastUpdatorID,
          updatedAt: diary[0].updatedAt,
        );
        selectedDiary.value = updatedDiary;
        subscription?.cancel();
      }
    });
  }

  getNickname() async {
    final String femaleUid = AuthController.to.group.value.femaleUid!;
    final String maleUid = AuthController.to.group.value.maleUid!;
    final maledata =
        await FirebaseFirestore.instance.collection('users').doc(maleUid).get();
    final femaledata = await FirebaseFirestore.instance
        .collection('users')
        .doc(femaleUid)
        .get();
    maleNickname(maledata.data()!['nickname'].toString());
    femaleNickname(femaledata.data()!['nickname'].toString());
  }

  @override
  void onClose() {
    diaryTabController.dispose();
    super.onClose();
  }

  void indexSelection(DiaryModel updatedDiary) {
    selectedDiary(updatedDiary);
  }

  void deleteDiary(DiaryModel selectedDiaryModel) async {
    for (var imgUrl in selectedDiaryModel.imgUrlList!) {
      await DiaryRepository().deleteDiaryImage(imgUrl);
    }
    await DiaryRepository().deleteDiary(selectedDiaryModel.diaryId!);
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
