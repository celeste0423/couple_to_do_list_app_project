import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListSuggestionPageController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController suggestionListTabController;

  static ListSuggestionPageController get to => Get.find();

  TextEditingController searchBarController = TextEditingController();
  List<String> _searchWord = [];
  bool isTextEmpty = true;
  Rx<bool> isSearchResult = false.obs;

  Rx<bool> isLiked = false.obs;

  Rx<BukkungListModel> selectedList = Rx<BukkungListModel>(BukkungListModel());

  //페이징컨트롤러<페이지 번호, 내용물> = PagingController(첫번째 페이지 키)
  PagingController<DocumentSnapshot<Map<String, dynamic>?>?,
          QueryDocumentSnapshot<Map<String, dynamic>>> pagingController =
      PagingController(firstPageKey: null);
  ScrollController suggestionListScrollController = ScrollController();
  var _scrollOffset = 0.0.obs;

  double get scrollOffset => _scrollOffset.value;
  int _pageSize = 10;
  StreamController<List<BukkungListModel>> streamController =
      StreamController<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? keyPage;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(length: 8, vsync: this);
    suggestionListTabController.addListener(() {
      //Todo: 탭 인덱스 변화에 따른 리스트 새로고침 테스트
      print('탭 변화 감지중');
      _onTabChanged;
    });
    searchBarController.addListener(onTextChanged);
    _initSelectedBukkungList();
    suggestionListScrollController.addListener(() {
      loadMoreBukkungLists();
    });
    pagingController.addPageRequestListener((pageKey) {
      _fetchSuggestionBukkungList(pageKey);
    });
  }

  void _onTabChanged() {
    _initSelectedBukkungList();
  }

  void _initSelectedBukkungList() {
    final stream = getSuggestionBukkungList(
        tabIndexToName(suggestionListTabController.index));
    StreamSubscription<List<BukkungListModel>>? subscription;
    subscription = stream.listen((list) {
      if (list.isNotEmpty) {
        final updatedList = selectedList.value.copyWith(
          listId: list[0].listId,
          title: list[0].title,
          content: list[0].content,
          location: list[0].location,
          category: list[0].category,
          imgUrl: list[0].imgUrl,
          imgId: list[0].imgId,
          madeBy: list[0].madeBy,
          likeCount: list[0].likeCount,
          likedUsers: list[0].likedUsers,
          viewCount: list[0].viewCount,
        );
        selectedList(updatedList);
        if (selectedList.value.likedUsers != null &&
            selectedList.value.likedUsers!
                .contains(AuthController.to.user.value.uid)) {
          isLiked(true);
        }
        subscription?.cancel();
      }
    });
  }

  void _fetchSuggestionBukkungList(
    DocumentSnapshot<Object?>? pageKey,
  ) {
    return ListSuggestionRepository.fetchSuggestionBukkungList(
      pageKey,
      _pageSize,
    );
  }

  @override
  void dispose() {
    super.dispose();
    suggestionListTabController.removeListener(() {
      _onTabChanged;
    });
    suggestionListTabController.dispose();
    searchBarController.dispose();
    suggestionListScrollController.dispose();
    pagingController.dispose();
  }

  void onTextChanged() {
    isTextEmpty = searchBarController.text.isEmpty;
    _searchWord = searchBarController.text.split(' ');
    isSearchResult(true);
    update(['searchResult'], true);
  }

  Stream<List<BukkungListModel>> getSearchedBukkungList() {
    return ListSuggestionRepository().getSearchedBukkungList(_searchWord);
  }

  String tabIndexToName(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'all';
      case 1:
        return '1travel';
      case 2:
        return '2meal';
      case 3:
        return '3activity';
      case 4:
        return '4culture';
      case 5:
        return '5study';
      case 6:
        return '6etc';
      default:
        return 'all';
    }
  }

  void loadNewBukkungLists() async {
    List<BukkungListModel> firstList = await ListSuggestionRepository()
        .getAllTestFutureBukkungList(_pageSize, null);
    streamController.add(firstList);
  }

  void loadMoreBukkungLists() async {
    if (suggestionListScrollController.position ==
        suggestionListScrollController.position.maxScrollExtent) {}
  }

  Stream<List<BukkungListModel>> getSuggestionTestBukkungList(
    String category,
  ) {
    if (category == 'all') {
      return ListSuggestionRepository().getAllTestStreamBukkungList(_pageSize);
    } else {
      return ListSuggestionRepository().getTypeBukkungList(category);
    }
  }

  Stream<List<BukkungListModel>> getSuggestionBukkungList(
    String category,
  ) {
    print('리스트 추천 stream(sugg cont) ${category}');
    if (category == 'all') {
      return ListSuggestionRepository().getAllBukkungList();
    } else {
      return ListSuggestionRepository().getTypeBukkungList(category);
    }
  }

  Stream<List<BukkungListModel>> getSuggestionMyBukkungList() {
    return ListSuggestionRepository().getMyBukkungList();
  }

  void indexSelection(BukkungListModel updatedList) {
    selectedList(updatedList);
    if (selectedList.value.likedUsers != null &&
        selectedList.value.likedUsers!
            .contains(AuthController.to.user.value.uid)) {
      print('좋아요 있음 (sug cont)${selectedList.value.likedUsers}');
      isLiked(true);
    } else {
      print('좋아요 없음 (sug cont)');
      isLiked(false);
    }
  }

  void toggleLike() {
    //Todo: 임시방편
    pagingController.refresh();
    if (selectedList.value.likedUsers != null) {
      if (selectedList.value.likedUsers!
          .contains(AuthController.to.user.value.uid)) {
        // 이미 userId가 존재하면 userId 제거 후 likeCount 감소
        print('좋아요 감소(sug cont)');
        selectedList.value.likedUsers!
            .remove(AuthController.to.user.value.uid!);
        final updatedList = selectedList.value.copyWith(
          likeCount: selectedList.value.likeCount! - 1,
          likedUsers: selectedList.value.likedUsers,
        );
        selectedList(updatedList);
        ListSuggestionRepository().updateLike(
          selectedList.value.listId!,
          selectedList.value.likeCount!,
          selectedList.value.likedUsers!,
        );
        isLiked(false);
      } else {
        // userId가 존재하지 않으면 userId 추가 후 likeCount 증가
        print('좋아요 추가(sug cont)');
        selectedList.value.likedUsers!.add(AuthController.to.user.value.uid!);
        final updatedList = selectedList.value.copyWith(
          likeCount: selectedList.value.likeCount! + 1,
          likedUsers: selectedList.value.likedUsers,
        );
        selectedList(updatedList);
        ListSuggestionRepository().updateLike(
          selectedList.value.listId!,
          selectedList.value.likeCount!,
          selectedList.value.likedUsers!,
        );
        isLiked(true);
      }
    } else {
      // likedUsers가 null이면 새로운 리스트 생성 후 userId 추가
      print('좋아요 null에서 추가(sug cont)');
      final updatedList = selectedList.value.copyWith(
        likeCount: selectedList.value.likeCount! + 1,
        likedUsers: [AuthController.to.user.value.uid!],
      );
      selectedList(updatedList);
      ListSuggestionRepository().updateLike(selectedList.value.listId!,
          selectedList.value.likeCount!, [AuthController.to.user.value.uid!]);
      isLiked(true);
    }
  }

  void viewCount() {
    ListSuggestionRepository().updateViewCount(
      selectedList.value.listId!,
      selectedList.value.viewCount! + 1,
    );
  }

  Future<void> listDelete() async {
    if (UploadBukkungListController.baseImageUrl != selectedList.value.imgUrl) {
      await ListSuggestionRepository()
          .deleteListImage('${selectedList.value.imgId!}.jpg');
    }
    ListSuggestionRepository().deleteList(
      selectedList.value.listId!,
    );
  }
}
