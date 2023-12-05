import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class AdminDiaryPageController extends GetxController
    with GetTickerProviderStateMixin {
  static AdminDiaryPageController get to => Get.find();

  ScrollController listByDateScrollController = ScrollController();
  StreamController<List<DiaryModel>> listByDateStreamController =
      BehaviorSubject<List<DiaryModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? listByDateKeyPage;
  List<DiaryModel>? listByDatePrevList;
  bool isListByDateLastPage = false;
  final int _pageSize = 20;

  @override
  void onInit() async {
    super.onInit();
    loadNewBukkungLists('date');
    listByDateScrollController.addListener(() {
      loadMoreBukkungLists('date');
    });
  }

  void loadNewBukkungLists(String type) async {
    List<DiaryModel> firstList =
        await getNewSuggestionListByDate(_pageSize, null, null);
    listByDateStreamController.add(firstList);
  }

  void loadMoreBukkungLists(String type) async {
    if (listByDateScrollController.position.pixels ==
        listByDateScrollController.position.maxScrollExtent) {
      if (!isListByDateLastPage) {
        List<DiaryModel> nextList = await getNewSuggestionListByDate(
            _pageSize, listByDateKeyPage, listByDatePrevList);
        listByDateStreamController.add(nextList);
      }
    }
  }

  Future<List<DiaryModel>> getNewSuggestionListByDate(
    int pageSize,
    QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
    List<DiaryModel>? prevList,
  ) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collectionGroup('diary')
        .orderBy('createdAt', descending: true);
    if (keyPage != null) {
      query = query.startAfterDocument(keyPage);
    }
    query = query.limit(pageSize);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
    List<DiaryModel> bukkungLists = prevList ?? [];
    for (var bukkungList in querySnapshot.docs) {
      bukkungLists.add(DiaryModel.fromJson(bukkungList.data()));
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
}
