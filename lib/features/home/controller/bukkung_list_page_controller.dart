import 'dart:async';

import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/notification_repository.dart';
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

  Rx<bool> isNotification = false.obs;
  Rx<bool> isAnimated = false.obs;
  // GifController gifController = GifController(vsync: this);

  Rx<String?> currentType = "category".obs;
  Map<String, String> typetoString = {
    "category": "카테고리 별",
    "created_at": "리스트 추가순",
    "date": "최신 날짜순",
    "redate": "이전 날짜순",
  };

  @override
  void onInit() {
    super.onInit();
    _checkNotification();
    _notificationAnimation();
    _loadSelectedListType();
    // myGroup(AuthController.to.group.value);
  }

  Future<void> sendAnalyticsEvent() async {
    await FirebaseAnalytics.instance
        .logEvent(name: 'view_product', parameters: {
      'product_id': 1234,
    });
  }

  void _checkNotification() async {
    isNotification(
      await NotificationRepository()
          .isUncheckedNotification(AuthController.to.user.value.uid!),
    );
  }

  void _notificationAnimation() {
    Timer.periodic(Duration(milliseconds: 300), (timer) {
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
    return BukkungListRepository().getGroupBukkungListByCategory();
  }

  Stream<List<BukkungListModel>> getAllBukkungList(String type) {
    // AuthController.to.saveGroupData();
    final GroupModel groupModel = AuthController.to.group.value;
    // final GroupModel groupModel = await AuthController.to.group.value;
    print('현재 그룹 (buk page cont)${groupModel.uid}');
    // print('현재 유저 (buk page cont)${myGroup.value.uid}');

    switch (type) {
      case 'created_at':
        return BukkungListRepository().getGroupBukkungListByCreatedAt();
      case 'date':
        return BukkungListRepository().getGroupBukkungListByDate();
      case 'redate':
        return BukkungListRepository().getGroupBukkungListByReverseDate();
      default:
        print('에러: 분류 타입 지정 안됨(buk cont)');
        return BukkungListRepository().getGroupBukkungListByDate();
    }
  }

  void deleteBukkungList(
      BukkungListModel bukkungListModel, bool isDeleteImage) async {
    if (isDeleteImage) {
      if (Constants.baseImageUrl != bukkungListModel.imgUrl &&
          null != bukkungListModel.imgUrl &&
          !bukkungListModel.imgUrl!.startsWith(
              "https://firebasestorage.googleapis.com/v0/b/bukkunglist.appspot.com/o/custom_app_image") &&
          bukkungListModel.imgUrl!.startsWith('https://firebasestorage')) {
        await BukkungListRepository()
            .deleteListImage('${bukkungListModel.imgId}.jpg');
      }
    }
    await BukkungListRepository().deleteList(bukkungListModel);
  }
}
