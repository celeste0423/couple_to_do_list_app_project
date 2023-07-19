import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/tutorial_coach_mark/pages/coachmark_desc.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ListSuggestionPageController extends GetxController
    with GetTickerProviderStateMixin {
  final BuildContext context;
  ListSuggestionPageController(this.context);
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey addKey = GlobalKey();
  GlobalKey likeKey = GlobalKey();
  GlobalKey copyKey = GlobalKey();

  late TabController suggestionListTabController;

  static ListSuggestionPageController get to => Get.find();

  TextEditingController searchBarController = TextEditingController();
  List<String> _searchWord = [];
  bool isTextEmpty = true;
  Rx<bool> isSearchResult = false.obs;

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

  Rx<BukkungListModel> selectedList = Rx<BukkungListModel>(BukkungListModel());
  int selectedListIndex = 0;

  ScrollController suggestionListScrollController = ScrollController();
  StreamController<List<BukkungListModel>> streamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? keyPage;
  List<BukkungListModel>? prevList;
  bool isLastPage = false;
  //페이지네이션 페이지 로딩 크기
  int _pageSize = 5;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController = TabController(length: 8, vsync: this);
    suggestionListTabController.addListener(() {
      //Todo: 탭 인덱스 변화에 따른 리스트 새로고침 테스트
      _onTabChanged();
    });
    searchBarController.addListener(onTextChanged);
    _initSelectedBukkungList();
    loadNewBukkungLists();
    suggestionListScrollController.addListener(() {
      loadMoreBukkungLists();
    });
    Future.delayed(const Duration(seconds: 1), () {
      _showTutorialCoachMark();
    });
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
    if (context!.mounted) {
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
            align: ContentAlign.bottom,
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
      TargetFocus(
        identify: "copy_key",
        keyTarget: copyKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "마음에 드는 추천리스트가 있다면 우리의 버꿍리스트로 가져오세요!",
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
      TargetFocus(
        identify: "like_key",
        keyTarget: likeKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "잘 만든 것 같다면 좋아요 꾹!",
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
    ];
  }

  void _onTabChanged() {
    _initSelectedBukkungList();
  }

  void _initSelectedBukkungList() {
    final stream = getSuggestionBukkungList(
        tabIndexToName(suggestionListTabController.index));
    StreamSubscription<List<BukkungListModel>>? subscription;
    subscription = stream.listen((list) async {
      if (list.isNotEmpty) {
        final updatedList = list[0];
        selectedList(updatedList);
        // print('리스트 변경 제목${list[0].listId}');
        // 리스트 레벨 가져오기
        UserModel? userData =
            await UserRepository.getUserDataByUid(updatedList.userId!);
        final int? expPoint = userData!.expPoint;
        userLevel(expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
        if (selectedList.value.likedUsers != null &&
            selectedList.value.likedUsers!
                .contains(AuthController.to.user.value.uid)) {
          isLiked(true);
        }
        subscription?.cancel();
      }
    });
  }

  void loadNewBukkungLists() async {
    List<BukkungListModel> firstList = await ListSuggestionRepository()
        .getAllNewBukkungList(_pageSize, null, null);
    streamController.add(firstList);
  }

  void loadMoreBukkungLists() async {
    if (suggestionListScrollController.position.pixels ==
        suggestionListScrollController.position.maxScrollExtent) {
      if (!isLastPage) {
        List<BukkungListModel> nextList = await ListSuggestionRepository()
            .getAllNewBukkungList(_pageSize, keyPage, prevList);
        streamController.add(nextList);
      }
    }
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
    streamController.close();
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

  Stream<List<BukkungListModel>> getSuggestionBukkungList(
    String category,
  ) {
    // print('리스트 추천 stream(sugg cont) ${category}');
    if (category == 'all') {
      return ListSuggestionRepository().getAllBukkungList();
    } else {
      return ListSuggestionRepository().getCategoryBukkungList(category);
    }
  }

  Stream<List<BukkungListModel>> getSuggestionMyBukkungList() {
    return ListSuggestionRepository().getMyBukkungList();
  }

  void indexSelection(BukkungListModel updatedList, int index) async {
    selectedList(updatedList);
    selectedListIndex = index;
    if (selectedList.value.likedUsers != null &&
        selectedList.value.likedUsers!
            .contains(AuthController.to.user.value.uid)) {
      // print('좋아요 있음 (sug cont)${selectedList.value.likedUsers}');
      isLiked(true);
    } else {
      // print('좋아요 없음 (sug cont)');
      isLiked(false);
    }
    int expPoint = 0;
    UserModel? userData =
        await UserRepository.getUserDataByUid(updatedList.userId!);
    print('유저 exp${userData!.expPoint}');
    if (userData.expPoint != null) {
      expPoint = userData.expPoint!;
    }
    userLevel((expPoint - expPoint % 100) ~/ 100);
    print('레벨${userLevel.value}');
  }

  void toggleLike() {
    if (selectedList.value.likedUsers != null) {
      if (selectedList.value.likedUsers!
          .contains(AuthController.to.user.value.uid)) {
        // 이미 userId가 존재하면 userId 제거 후 likeCount 감소
        // print('좋아요 감소(sug cont)');
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
        //오프라인 리스트 업데이트
        if (suggestionListTabController.index == 0) {
          prevList![selectedListIndex].likeCount =
              selectedList.value.likeCount!;
          streamController.add(prevList!);
        }
        //화면 업데이트
        isLiked(false);
      } else {
        // userId가 존재하지 않으면 userId 추가 후 likeCount 증가
        // print('좋아요 추가(sug cont)');
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
        //오프라인 리스트 업데이트
        if (suggestionListTabController.index == 0) {
          prevList![selectedListIndex].likeCount =
              selectedList.value.likeCount!;
          streamController.add(prevList!);
        }
        //화면 업데이트
        isLiked(true);
      }
    } else {
      // likedUsers가 null이면 새로운 리스트 생성 후 userId 추가
      // print('좋아요 null에서 추가(sug cont)');
      final updatedList = selectedList.value.copyWith(
        likeCount: selectedList.value.likeCount! + 1,
        likedUsers: [AuthController.to.user.value.uid!],
      );
      selectedList(updatedList);
      ListSuggestionRepository().updateLike(selectedList.value.listId!,
          selectedList.value.likeCount!, [AuthController.to.user.value.uid!]);
      //오프라인 리스트 업데이트
      if (suggestionListTabController.index == 0) {
        prevList![selectedListIndex].likeCount = selectedList.value.likeCount!;
        streamController.add(prevList!);
      }
      //화면 업데이트
      isLiked(true);
    }
  }

  void viewCount() {
    // print(
    //     '${selectedList.value.userId},${AuthController.to.group.value.femaleUid}');
    if (selectedList.value.userId != AuthController.to.group.value.femaleUid &&
        selectedList.value.userId != AuthController.to.group.value.maleUid) {
      // print(
      //     '${selectedList.value.userId},${AuthController.to.group.value.maleUid}');
      ListSuggestionRepository().updateViewCount(
        selectedList.value.listId!,
        selectedList.value.viewCount! + 1,
      );
      //오프라인 리스트 업데이트
      if (suggestionListTabController.index == 0) {
        prevList![selectedListIndex].viewCount =
            selectedList.value.viewCount! + 1;
        streamController.add(prevList!);
      }
    }
  }

  Future<void> listDelete() async {
    if (Constants.baseImageUrl != selectedList.value.imgUrl) {
      await ListSuggestionRepository()
          .deleteListImage('${selectedList.value.imgId!}.jpg');
    }
    ListSuggestionRepository().deleteList(
      selectedList.value.listId!,
    );
  }
}
