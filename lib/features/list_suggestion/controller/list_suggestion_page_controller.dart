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

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(length: 6, vsync: this);
    searchBarController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  void _onTextChanged() {
    isTextEmpty = searchBarController.text.isEmpty;
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

  Stream<List<BukkungListModel>> getSuggestionAllBukkungList() {
    return ListSuggestionRepository().getAllBukkungList();
  }

  Future<List<BukkungListModel>> getSuggestionBukkungList(
      String category) async {
    print('리스트 추천 stream(sugg cont) ${category}');
    return await ListSuggestionRepository().getTypeBukkungList(category);
  }
}
