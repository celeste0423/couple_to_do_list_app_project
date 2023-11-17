import 'dart:async';

import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BukkungListPageController extends GetxController {
  static BukkungListPageController get to => Get.find();

  GlobalKey listSuggestionKey = GlobalKey();
  GlobalKey bukkungListKey = GlobalKey();

  // Rx<GroupModel> myGroup = GroupModel().obs;
  Rx<BukkungListModel> bukkungList = BukkungListModel().obs;

  Rx<bool> isAnimated = false.obs;

  Rx<String?> currentType = "category".obs;
  Map<String, String> typetoString = {
    "category": "카테고리 별",
    "date": "최신 순",
    "redate": "이전 순",
  };

  @override
  void onInit() {
    super.onInit();
    addButtonAnimation();
    _loadSelectedListType();
    // myGroup(AuthController.to.group.value);
  }

  Future<void> sendAnalyticsEvent() async {
    await FirebaseAnalytics.instance
        .logEvent(name: 'view_product', parameters: {
      'product_id': 1234,
    });
  }

  void addButtonAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      isAnimated(!isAnimated.value);
    });
  }

  void _loadSelectedListType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentType(prefs.getString('selectedListType') ?? 'category');
  }

  void saveSelectedListType(String listType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedListType', listType);
  }

  Stream<Map<String, dynamic>> getAllBukkungListByCategory() {
    // print('리스트 로드 ${AuthController.to.group.value.uid}');
    // print('리스트 로드 ${AuthController.to.group.value.maleUid}');
    // print('리스트 로드 ${AuthController.to.group.value.femaleUid}');
    final GroupModel groupModel = AuthController.to.group.value;
    return BukkungListRepository(groupModel: groupModel)
        .getGroupBukkungListByCategory();
  }

  Stream<List<BukkungListModel>> getAllBukkungList(String type) {
    // AuthController.to.saveGroupData();
    final GroupModel groupModel = AuthController.to.group.value;
    // final GroupModel groupModel = await AuthController.to.group.value;
    print('현재 그룹 (buk page cont)${groupModel.uid}');
    // print('현재 유저 (buk page cont)${myGroup.value.uid}');

    switch (type) {
      case 'date':
        return BukkungListRepository(groupModel: groupModel)
            .getGroupBukkungListByDate();
      case 'redate':
        return BukkungListRepository(groupModel: groupModel)
            .getGroupBukkungListByReverseDate();
      default:
        print('에러: 분류 타입 지정 안됨(buk cont)');
        return BukkungListRepository(groupModel: groupModel)
            .getGroupBukkungListByDate();
    }
  }

  void deleteBukkungList(
      BukkungListModel bukkungListModel, bool isDeleteImage) async {
    final GroupModel groupModel = AuthController.to.group.value;
    if (isDeleteImage) {
      if (Constants.baseImageUrl != bukkungListModel.imgUrl) {
        await BukkungListRepository(groupModel: groupModel)
            .deleteListImage('${bukkungListModel.imgId}.jpg');
      }
    }
    await BukkungListRepository(groupModel: groupModel)
        .deleteList(bukkungListModel);
  }
}
