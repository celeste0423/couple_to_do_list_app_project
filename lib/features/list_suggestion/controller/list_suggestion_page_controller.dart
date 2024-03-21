import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListSuggestionPageController extends GetxController
    with GetTickerProviderStateMixin {
  static ListSuggestionPageController get to => Get.find();

  ListSuggestionPageController();

  late TabController suggestionListTabController;
  final int initialTabIndex = Get.arguments ?? 0;

  TextEditingController searchBarController = TextEditingController();
  List<String> _searchWord = [];
  bool isTextEmpty = true;
  Rx<bool> isSearchResult = false.obs;

  RxList<String> categories = [
    "1travel",
    "2meal",
    "3activity",
    "4culture",
    "5study",
    "6etc",
  ].obs;
  RxList<String> selectedCategories = RxList();
  Map<String, String> categoryToString = {
    "1travel": "여행",
    "2meal": "식사",
    "3activity": "액티비티",
    "4culture": "문화 활동",
    "5study": "자기 계발",
    "6etc": "기타",
  };

  PagingController<DocumentSnapshot<Map<String, dynamic>>?,
          QueryDocumentSnapshot<Map<String, dynamic>>>
      listPagingControllerByDate = PagingController(firstPageKey: null);
  PagingController<DocumentSnapshot<Map<String, dynamic>>?,
          QueryDocumentSnapshot<Map<String, dynamic>>>
      listPagingControllerByCopy = PagingController(firstPageKey: null);
  PagingController<DocumentSnapshot<Map<String, dynamic>>?,
          QueryDocumentSnapshot<Map<String, dynamic>>> listPagingControllerMy =
      PagingController(firstPageKey: null);

  ScrollController listScrollControllerByDate = ScrollController();
  ScrollController listScrollControllerByCopy = ScrollController();
  ScrollController listScrollControllerMy = ScrollController();

  final _scrollOffsetByDate = 0.0.obs;
  final _scrollOffsetByCopy = 0.0.obs;
  final _scrollOffsetMy = 0.0.obs;

  double get scrollOffsetByDate => _scrollOffsetByDate.value;
  double get scrollOffsetByCopy => _scrollOffsetByCopy.value;
  double get scrollOffsetMy => _scrollOffsetMy.value;

  final _suggestionListByDate =
      Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]);
  final _suggestionListByCopy =
      Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]);
  final _suggestionListMy =
      Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]);

  List<QueryDocumentSnapshot<BukkungListModel>> get suggestionListByDate =>
      _suggestionListByDate.value;
  List<QueryDocumentSnapshot<BukkungListModel>> get suggestionListByCopy =>
      _suggestionListByCopy.value;
  List<QueryDocumentSnapshot<BukkungListModel>> get suggestionListMy =>
      _suggestionListMy.value;

  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    searchBarController.addListener(onTextChanged);
    _tabControllerInit();
    _initPagination();
  }

  void _tabControllerInit() {
    suggestionListTabController = TabController(
      initialIndex: initialTabIndex,
      length: 3,
      vsync: this,
    );
  }

  void _initPagination() {
    listScrollControllerByDate.addListener(() {
      _scrollOffsetByCopy.value = listScrollControllerByDate.offset;
    });
    listPagingControllerByDate.addPageRequestListener((pageKey) {
      fetchDateSuggestionList(pageKey);
    });

    listScrollControllerByCopy.addListener(() {
      _scrollOffsetByCopy.value = listScrollControllerByCopy.offset;
    });
    listPagingControllerByCopy.addPageRequestListener((pageKey) {
      fetchCopySuggestionList(pageKey);
    });

    listScrollControllerMy.addListener(() {
      _scrollOffsetMy.value = listScrollControllerMy.offset;
    });
    listPagingControllerMy.addPageRequestListener((pageKey) {
      fetchMySuggestionList(pageKey);
    });
  }

  //on Init

  void onTextChanged() {
    isTextEmpty = searchBarController.text.isEmpty;
    _searchWord = searchBarController.text.split(' ');
    isSearchResult(true);
    update(['searchResult'], true);
  }

  Stream<List<BukkungListModel>> getSearchedBukkungList() {
    return ListSuggestionRepository().getSearchedBukkungList(_searchWord);
  }

  void fetchDateSuggestionList(DocumentSnapshot<Object?>? pageKey) async {
    QuerySnapshot<Map<String, dynamic>> loadedSuggestionList;
    loadedSuggestionList =
        await ListSuggestionRepository().getSuggestionListByDate(
      pageKey,
      _pageSize,
    );
    final isLastPage = loadedSuggestionList.docs.length < _pageSize;
    if (isLastPage) {
      listPagingControllerByDate.appendLastPage(loadedSuggestionList.docs);
    } else {
      final nextPageKey = loadedSuggestionList.docs.last;
      listPagingControllerByDate.appendPage(
          loadedSuggestionList.docs, nextPageKey);
    }
  }

  void fetchCopySuggestionList(DocumentSnapshot<Object?>? pageKey) async {
    QuerySnapshot<Map<String, dynamic>> loadedSuggestionList;
    loadedSuggestionList =
        await ListSuggestionRepository().getSuggestionListByCopy(
      pageKey,
      _pageSize,
    );
    print('펫치 ${loadedSuggestionList.docs.length}');
    final isLastPage = loadedSuggestionList.docs.length < _pageSize;
    if (isLastPage) {
      print('마지막');
      listPagingControllerByCopy.appendLastPage(loadedSuggestionList.docs);
    } else {
      print('아님');
      final nextPageKey = loadedSuggestionList.docs.last;
      listPagingControllerByCopy.appendPage(
          loadedSuggestionList.docs, nextPageKey);
    }
  }

  void fetchMySuggestionList(DocumentSnapshot<Object?>? pageKey) async {
    QuerySnapshot<Map<String, dynamic>> loadedSuggestionList;
    loadedSuggestionList = await ListSuggestionRepository().getSuggestionListMy(
      pageKey,
      _pageSize,
    );
    final isLastPage = loadedSuggestionList.docs.length < _pageSize;
    if (isLastPage) {
      listPagingControllerMy.appendLastPage(loadedSuggestionList.docs);
    } else {
      final nextPageKey = loadedSuggestionList.docs.last;
      listPagingControllerMy.appendPage(loadedSuggestionList.docs, nextPageKey);
    }
  }

  Future<void> listDelete(BukkungListModel bukkungListModel) async {
    if (Constants.baseImageUrl != bukkungListModel.imgUrl &&
        bukkungListModel.imgUrl!.startsWith('https://firebasestorage')) {
      await ListSuggestionRepository()
          .deleteListImage('${bukkungListModel.imgId!}.jpg');
    }
    ListSuggestionRepository().deleteList(
      bukkungListModel.listId!,
    );
  }

  void addViewCount(BukkungListModel selectedList) {
    ListSuggestionRepository().updateViewCount(
      selectedList.listId!,
      selectedList.viewCount! + 1,
    );
  }

  @override
  void onClose() {
    searchBarController.dispose();
    listScrollControllerByDate.dispose();
    listScrollControllerByCopy.dispose();
    listScrollControllerMy.dispose();
    listPagingControllerByDate.dispose();
    listPagingControllerByCopy.dispose();
    listPagingControllerMy.dispose();
    super.onClose(); // 부모 클래스의 onClose 메서드를 호출
  }
}
