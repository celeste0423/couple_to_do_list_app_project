import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSuggestionPageController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController suggestionListTabController;

  static ListSuggestionPageController get to => Get.find();

  TextEditingController searchBarController = TextEditingController();
  bool isTextEmpty = true;

  Rx<bool> isLiked = false.obs;

  Rx<BukkungListModel> selectedList = Rx<BukkungListModel>(BukkungListModel());
  Rx<int> selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(length: 8, vsync: this);
    // suggestionListTabController.addListener(() {
    //   print('탭 변화 감지중');
    //   _onTabChanged;
    // });
    searchBarController.addListener(_onTextChanged);
    _initMainImage();
  }

  void _initMainImage() async {
    final list =
        await getSuggestionBukkungList(tabIndexToName(selectedIndex.value));
    if (list.isNotEmpty) {
      final updatedList = selectedList.value.copyWith(
        listId: list[0].listId,
        title: list[0].title,
        content: list[0].content,
        location: list[0].location,
        category: list[0].category,
        imgUrl: list[0].imgUrl,
        madeBy: list[0].madeBy,
        likeCount: list[0].likeCount,
        likedUsers: list[0].likedUsers,
      );
      selectedList.value = updatedList;
      if (selectedList.value.likedUsers != null &&
          selectedList.value.likedUsers!
              .contains(AuthController.to.user.value.uid)) {
        isLiked(true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // suggestionListTabController.removeListener(() {
    //   _onTabChanged;
    // });
    suggestionListTabController.dispose();
    searchBarController.dispose();
  }

  void _onTextChanged() {
    isTextEmpty = searchBarController.text.isEmpty;
  }

  void _onTabChanged() {
    selectedIndex.value = 0;
    _initMainImage();
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

  Future<List<BukkungListModel>> getSuggestionBukkungList(
    String category,
  ) async {
    print('리스트 추천 stream(sugg cont) ${category}');
    if (category == 'all') {
      return ListSuggestionRepository().getAllBukkungList();
    } else {
      return await ListSuggestionRepository().getTypeBukkungList(category);
    }
  }

  Future<List<BukkungListModel>> getSuggestionMyBukkungList() async {
    return ListSuggestionRepository().getMyBukkungList();
  }

  void indexSelection(int index, BukkungListModel updatedList) {
    selectedIndex(index);
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
    if (selectedList.value.likedUsers != null) {
      if (selectedList.value.likedUsers!
          .contains(AuthController.to.user.value.uid)) {
        // 이미 userId가 존재하면 userId 제거 후 likeCount 감소
        print('좋아요 감소(sug cont)');
        selectedList.value.likedUsers!
            .remove(AuthController.to.user.value.uid!);
        ListSuggestionRepository().updateLike(selectedList.value.listId!,
            selectedList.value.likeCount! - 1, selectedList.value.likedUsers!);
        isLiked(false);
      } else {
        // userId가 존재하지 않으면 userId 추가 후 likeCount 증가
        print('좋아요 추가(sug cont)');
        selectedList.value.likedUsers!.add(AuthController.to.user.value.uid!);
        ListSuggestionRepository().updateLike(selectedList.value.listId!,
            selectedList.value.likeCount! + 1, selectedList.value.likedUsers!);
        isLiked(true);
      }
    } else {
      // likedUsers가 null이면 새로운 리스트 생성 후 userId 추가
      print('좋아요 null에서 추가(sug cont)');
      ListSuggestionRepository().updateLike(
          selectedList.value.listId!,
          selectedList.value.likeCount! + 1,
          [AuthController.to.user.value.uid!]);
      isLiked(true);
    }
  }
}
