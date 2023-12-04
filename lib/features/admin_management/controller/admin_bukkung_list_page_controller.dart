import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBukkungListPageController extends GetxController {
  static AdminBukkungListPageController get to => Get.find();

  ScrollController listByDateScrollController = ScrollController();
  StreamController<List<BukkungListModel>> listByDateStreamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? listByDateKeyPage;
  List<BukkungListModel>? listByDatePrevList;
  bool isListByDateLastPage = false;
  final int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadNewBukkungLists('date');
    listByDateScrollController.addListener(() {
      loadMoreBukkungLists('date');
    });
  }

  void loadNewBukkungLists(String type) async {
    List<BukkungListModel> firstList =
        await getNewSuggestionListByDate(_pageSize, null, null);
    listByDateStreamController.add(firstList);
  }

  void loadMoreBukkungLists(String type) async {
    if (listByDateScrollController.position.pixels ==
        listByDateScrollController.position.maxScrollExtent) {
      if (!isListByDateLastPage) {
        List<BukkungListModel> nextList = await getNewSuggestionListByDate(
            _pageSize, listByDateKeyPage, listByDatePrevList);
        listByDateStreamController.add(nextList);
      }
    }
  }

  Future<List<BukkungListModel>> getNewSuggestionListByDate(
    int pageSize,
    QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
    List<BukkungListModel>? prevList,
  ) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collectionGroup('bukkungLists')
        .orderBy('createdAt', descending: true);
    if (keyPage != null) {
      query = query.startAfterDocument(keyPage);
    }
    query = query.limit(pageSize);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
    List<BukkungListModel> bukkungLists = prevList ?? [];
    for (var bukkungList in querySnapshot.docs) {
      bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
    }
    //키페이지 설정
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
    listByDateKeyPage = lastDocument;
    //이전 리스트 저장
    listByDatePrevList = bukkungLists;
    //마지막 페이지인지 여부 확인
    if (querySnapshot.docs.length < pageSize) {
      isListByDateLastPage = true;
    }
    return bukkungLists;
  }

  // Stream<List<BukkungListModel>> getAllBukkungListByCreatedAt() {
  //   return
  // }

  void deleteBukkungList(
      BukkungListModel bukkungListModel, bool isDeleteImage) async {
    final GroupModel groupModel = AuthController.to.group.value;
    if (isDeleteImage) {
      if (Constants.baseImageUrl != bukkungListModel.imgUrl) {
        await BukkungListRepository()
            .deleteListImage('${bukkungListModel.imgId}.jpg');
      }
    }
    await BukkungListRepository().deleteList(bukkungListModel);
  }
}
