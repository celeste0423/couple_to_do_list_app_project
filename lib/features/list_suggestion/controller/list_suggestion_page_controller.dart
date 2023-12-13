import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/tutorial_coach_mark/pages/coachmark_desc.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/copy_count_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/copy_count_repository.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uuid/uuid.dart';

class ListSuggestionPageController extends GetxController
    with GetTickerProviderStateMixin {
  static ListSuggestionPageController get to => Get.find();

  final BuildContext context;
  ListSuggestionPageController(this.context);
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  //튜토리얼 위치 키
  GlobalKey addKey = GlobalKey();

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
  Rx<bool> isLiked = false.obs;
  Rx<int> userLevel = 0.obs;

  Rx<bool> isNextListLoading = false.obs;

  ScrollController listByLikeScrollController = ScrollController();
  StreamController<List<BukkungListModel>> listByLikeStreamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? listByLikeKeyPage;
  List<BukkungListModel>? listByLikePrevList;
  bool isListByLikeLastPage = false;

  ScrollController listByDateScrollController = ScrollController();
  StreamController<List<BukkungListModel>> listByDateStreamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? listByDateKeyPage;
  List<BukkungListModel>? listByDatePrevList;
  bool isListByDateLastPage = false;

  ScrollController listByViewScrollController = ScrollController();
  StreamController<List<BukkungListModel>> listByViewStreamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? listByViewKeyPage;
  List<BukkungListModel>? listByViewPrevList;
  bool isListByViewLastPage = false;

  Stream<List<BukkungListModel>> getSuggestionMyBukkungList() {
    return ListSuggestionRepository().getMyBukkungList();
  }

  Rx<bool> noMyList = false.obs;

  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(
      initialIndex: initialTabIndex,
      length: 4,
      vsync: this,
    );
    searchBarController.addListener(onTextChanged);
    loadNewBukkungLists('like');
    loadNewBukkungLists('date');
    loadNewBukkungLists('view');
    listByLikeScrollController.addListener(() {
      if (!isNextListLoading.value) {
        loadMoreBukkungLists('like');
      }
    });
    listByDateScrollController.addListener(() {
      if (!isNextListLoading.value) {
        loadMoreBukkungLists('date');
      }
    });
    listByViewScrollController.addListener(() {
      if (!isNextListLoading.value) {
        loadMoreBukkungLists('view');
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      _showTutorialCoachMark();
    });
  }

  @override
  void onClose() {
    // 컨트롤러에서 사용한 리소스를 해제 또는 정리하는 로직 추가
    // suggestionListTabController.dispose();
    searchBarController.dispose();
    listByLikeScrollController.dispose();
    listByDateScrollController.dispose();
    listByViewScrollController.dispose();

    super.onClose(); // 부모 클래스의 onClose 메서드를 호출
  }

  @override
  void dispose() {
    super.dispose();
    suggestionListTabController.dispose();
    searchBarController.dispose();
    listByLikeScrollController.dispose();
    listByLikeStreamController.close();
    listByDateScrollController.dispose();
    listByDateStreamController.close();
    listByViewScrollController.dispose();
    listByViewStreamController.close();
  }

  void _showTutorialCoachMark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownSuggestionTutorial =
        prefs.getBool('hasShownSuggestionTutorial') ?? false;
    if (hasShownSuggestionTutorial) {
      //이미 튜토리얼을 진행했으면 튜토리얼 종료
      return;
    }
    _initTarget(); //타겟 더하기
    if (context.mounted) {
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        hideSkip: true,
        onClickTarget: (target) {},
      )..show(context: context);
      await prefs.setBool('hasShownSuggestionTutorial', true);
    }
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "add_key",
        keyTarget: addKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "버튼을 눌러 나만의 버꿍리스트를 만들 수 있습니다.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      //Todo: 튜토리얼 추가하기
    ];
  }

  void loadNewBukkungLists(String type) async {
    switch (type) {
      case 'like':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewListByLike(_pageSize, null, null, selectedCategories);
          listByLikeStreamController.add(firstList);
        }
      case 'date':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewListByDate(_pageSize, null, null, selectedCategories);
          listByDateStreamController.add(firstList);
        }
      case 'view':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewListByView(_pageSize, null, null, selectedCategories);
          listByViewStreamController.add(firstList);
        }
      default:
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewListByLike(_pageSize, null, null, selectedCategories);
          listByLikeStreamController.add(firstList);
        }
    }
  }

  void loadMoreBukkungLists(String type) async {
    switch (type) {
      case 'like':
        {
          if (listByLikeScrollController.position.extentAfter < 200) {
            if (!isListByLikeLastPage) {
              isNextListLoading(true);
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewListByLike(_pageSize, listByLikeKeyPage,
                      listByLikePrevList, selectedCategories);
              listByLikeStreamController.add(nextList);
              isNextListLoading(false);
            }
          }
        }
      case 'date':
        {
          if (listByDateScrollController.position.extentAfter < 200) {
            if (!isListByDateLastPage) {
              isNextListLoading(true);
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewListByDate(_pageSize, listByDateKeyPage,
                      listByDatePrevList, selectedCategories);
              listByDateStreamController.add(nextList);
              isNextListLoading(false);
            }
          }
        }
      case 'view':
        {
          if (listByViewScrollController.position.extentAfter < 200) {
            if (!isListByViewLastPage) {
              isNextListLoading(true);
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewListByView(_pageSize, listByViewKeyPage,
                      listByViewPrevList, selectedCategories);
              listByViewStreamController.add(nextList);
              isNextListLoading(false);
            }
          }
        }
      default:
        {
          if (listByLikeScrollController.position.pixels ==
              listByLikeScrollController.position.maxScrollExtent) {
            if (!isListByLikeLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewListByLike(_pageSize, listByLikeKeyPage,
                      listByLikePrevList, selectedCategories);
              listByLikeStreamController.add(nextList);
            }
          }
        }
    }
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
}
