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

  List<
      PagingController<DocumentSnapshot<Map<String, dynamic>>?,
          QueryDocumentSnapshot<Map<String, dynamic>>>> listPagingController = [
    PagingController(firstPageKey: null),
    PagingController(firstPageKey: null),
    PagingController(firstPageKey: null),
    PagingController(firstPageKey: null),
  ];
  List<ScrollController> listScrollController = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];
  final _scrollOffset = [
    0.0.obs,
    0.0.obs,
    0.0.obs,
    0.0.obs,
  ];

  List<double> get scrollOffset => [
        _scrollOffset[0].value,
        _scrollOffset[1].value,
        _scrollOffset[2].value,
        _scrollOffset[3].value,
      ];
  final _suggestionList = [
    Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]),
    Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]),
    Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]),
    Rx<List<QueryDocumentSnapshot<BukkungListModel>>>([]),
  ];

  List<List<QueryDocumentSnapshot<BukkungListModel>>> get suggestionList => [
        _suggestionList[0].value,
        _suggestionList[1].value,
        _suggestionList[2].value,
        _suggestionList[3].value,
      ];

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
      length: 4,
      vsync: this,
    );
  }

  void _initPagination() {
    listScrollController[0].addListener(() {
      _scrollOffset[0].value = listScrollController[0].offset;
    });
    listPagingController[0].addPageRequestListener((pageKey) {
      fetchSuggestionList(pageKey);
    });

    listScrollController[1].addListener(() {
      _scrollOffset[1].value = listScrollController[1].offset;
    });
    listPagingController[1].addPageRequestListener((pageKey) {
      fetchSuggestionList(pageKey);
    });

    listScrollController[2].addListener(() {
      _scrollOffset[2].value = listScrollController[2].offset;
    });
    listPagingController[2].addPageRequestListener((pageKey) {
      fetchSuggestionList(pageKey);
    });
    listScrollController[3].addListener(() {
      _scrollOffset[3].value = listScrollController[3].offset;
    });
    listPagingController[3].addPageRequestListener((pageKey) {
      fetchSuggestionList(pageKey);
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

  void fetchSuggestionList(DocumentSnapshot<Object?>? pageKey) async {
    QuerySnapshot<Map<String, dynamic>> loadedSuggestionList;
    loadedSuggestionList =
        await ListSuggestionRepository().getSuggestionListByDate(
      pageKey,
      _pageSize,
    );
    final isLastPage = loadedSuggestionList.docs.length < _pageSize;
    if (isLastPage) {
      listPagingController.appendLastPage(loadedSuggestionList.docs);
    } else {
      final nextPageKey = loadedSuggestionList.docs.last;
      listPagingController.appendPage(loadedSuggestionList.docs, nextPageKey);
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
    listScrollController.dispose();
    super.onClose(); // 부모 클래스의 onClose 메서드를 호출
  }
}
