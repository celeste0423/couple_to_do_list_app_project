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

  Rx<BukkungListModel> selectedList = Rx<BukkungListModel>(BukkungListModel());

  Rx<int> selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(length: 6, vsync: this);
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
        title: list[0].title,
        content: list[0].content,
        location: list[0].location,
        category: list[0].category,
        imgUrl: list[0].imgUrl,
        madeBy: list[0].madeBy,
      );
      selectedList.value = updatedList;
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
        return 'travel';
      case 2:
        return 'activity';
      case 3:
        return 'meal';
      case 4:
        return 'culture';
      case 5:
        return 'etc';
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

  void indexSelection(int index) {
    selectedIndex(index);
  }
}
