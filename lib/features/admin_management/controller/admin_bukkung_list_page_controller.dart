import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

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

  void deleteBukkungList(
      BukkungListModel bukkungListModel, bool isDeleteImage) async {
    if (isDeleteImage) {
      if (Constants.baseImageUrl != bukkungListModel.imgUrl) {
        await BukkungListRepository()
            .deleteListImage('${bukkungListModel.imgId}.jpg');
      }
    }
    await BukkungListRepository().deleteList(bukkungListModel);
  }

  Future<void> updateAutoImage(BukkungListModel bukkungListData) async {
    try {
      // Query를 실행하여 listId가 일치하는 모든 bukkungList를 가져옵니다.
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collectionGroup('bukkungLists')
          .where('listId', isEqualTo: bukkungListData.listId)
          .get();
      // 가져온 각각의 문서에 대해 업데이트를 수행합니다.
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        // 업데이트를 수행할 문서의 참조를 가져옵니다.
        DocumentReference documentReference = doc.reference;
        String? updatedImgUrl = await getOnlineImage(bukkungListData.title!);
        if (updatedImgUrl != null) {
          // 업데이트할 데이터를 작성합니다.
          Map<String, dynamic> updatedData = {
            'imgUrl': updatedImgUrl,
          };
          // 문서를 업데이트합니다.
          await documentReference.update(updatedData);
        }
      }
      print('업데이트가 완료되었습니다.');
    } catch (e) {
      print('업데이트 중 오류가 발생했습니다: $e');
    }
  }

  Future<String?> getOnlineImage(String searchWords) async {
    final response = await http.get(
      Uri.parse(
          "https://api.pexels.com/v1/search?query=$searchWords&locale=ko-KR&per_page=1"),
      headers: {
        'Authorization':
            'vj40CWvim48eP6I6ymW21oHCbU50DVS4Dyj8y4b4GZVIKaWaT9EisapB'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      // 안전하게 null 체크를 수행하고 photos가 없으면 null을 반환
      List<dynamic>? photos = data['photos'];
      if (photos == null || photos.isEmpty) {
        return null;
      }
      Map<String, dynamic>? firstPhoto = photos[0];
      if (firstPhoto == null) {
        return null;
      }
      String? originalImageUrl = firstPhoto['src']['original'];
      return originalImageUrl;
    } else {
      // 오류가 발생한 경우에도 null 반환
      print('추천 사진 없음 오류 (upl buk cont)');
      return null;
    }
  }
}
