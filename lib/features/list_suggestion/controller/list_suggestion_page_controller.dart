import 'dart:async';
import 'dart:math';

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
  final BuildContext context;
  ListSuggestionPageController(this.context);
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey addKey = GlobalKey();
  GlobalKey likeKey = GlobalKey();
  GlobalKey copyKey = GlobalKey();

  late TabController suggestionListTabController;
  final int initialTabIndex = Get.arguments ?? 0;

  static ListSuggestionPageController get to => Get.find();

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
  Rx<bool> isCategory = false.obs;
  RxList<String> selectedCategories = RxList();
  Map<String, String> stringToCategory = {
    "여행": "1travel",
    "식사": "2meal",
    "액티비티": "3activity",
    "문화 활동": "4culture",
    "자기 계발": "5study",
    "기타": "6etc",
  };

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
  // int selectedListIndex = 0;

  Timer _paginationTimer = Timer(Duration(milliseconds: 0), () {});

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

  ScrollController favoriteListScrollController = ScrollController();
  StreamController<List<BukkungListModel>> favoriteListStreamController =
      BehaviorSubject<List<BukkungListModel>>();
  QueryDocumentSnapshot<Map<String, dynamic>>? favoriteListKeyPage;
  List<BukkungListModel>? favoriteListPrevList;
  bool isfavoriteListLastPage = false;
  Rx<bool> noFavoriteList = false.obs;

  Stream<List<BukkungListModel>> getSuggestionMyBukkungList() {
    return ListSuggestionRepository().getMyBukkungList();
  }

  Rx<bool> noMyList = false.obs;

  final int _pageSize = 5;

  @override
  void onInit() {
    super.onInit();
    suggestionListTabController =
        TabController(initialIndex: initialTabIndex, length: 5, vsync: this);
    suggestionListTabController.addListener(() {
      _onTabChanged();
    });
    searchBarController.addListener(onTextChanged);
    initSelectedBukkungList();
    loadNewBukkungLists('like');
    loadNewBukkungLists('date');
    loadNewBukkungLists('view');
    loadNewBukkungLists('favorite');
    listByLikeScrollController.addListener(() {
      if (!_paginationTimer.isActive) {
        loadMoreBukkungLists('like');
      }
    });
    listByDateScrollController.addListener(() {
      if (!_paginationTimer.isActive) {
        loadMoreBukkungLists('date');
      }
    });
    listByViewScrollController.addListener(() {
      if (!_paginationTimer.isActive) {
        loadMoreBukkungLists('view');
      }
    });
    favoriteListScrollController.addListener(() {
      loadMoreBukkungLists('favorite');
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
    favoriteListScrollController.dispose();

    super.onClose(); // 부모 클래스의 onClose 메서드를 호출
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
    initSelectedBukkungList();
  }

  void initSelectedBukkungList() {
    // print(suggestionListTabController.index);
    switch (suggestionListTabController.index) {
      case 0:
        {
          noFavoriteList(false);
          noMyList(false);
          final stream = listByLikeStreamController.stream;
          StreamSubscription<List<BukkungListModel>>? subscription;
          subscription = stream.listen((list) async {
            if (list.isNotEmpty) {
              final updatedList = list[0];
              selectedList(updatedList);
              // 리스트 레벨 가져오기
              UserModel? userData =
                  await UserRepository.getUserDataByUid(updatedList.userId!);
              final int? expPoint = userData!.expPoint;
              userLevel(
                  expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
              if (selectedList.value.likedUsers != null &&
                  selectedList.value.likedUsers!
                      .contains(AuthController.to.user.value.uid)) {
                isLiked(true);
              }
              subscription?.cancel();
            }
          });
        }
      case 1:
        {
          noFavoriteList(false);
          noMyList(false);
          final stream = listByDateStreamController.stream;
          StreamSubscription<List<BukkungListModel>>? subscription;
          subscription = stream.listen((list) async {
            if (list.isNotEmpty) {
              final updatedList = list[0];
              selectedList(updatedList);
              // 리스트 레벨 가져오기
              UserModel? userData =
                  await UserRepository.getUserDataByUid(updatedList.userId!);
              final int? expPoint = userData!.expPoint;
              userLevel(
                  expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
              if (selectedList.value.likedUsers != null &&
                  selectedList.value.likedUsers!
                      .contains(AuthController.to.user.value.uid)) {
                isLiked(true);
              }
              subscription?.cancel();
            }
          });
        }
      case 2:
        {
          noFavoriteList(false);
          noMyList(false);
          final stream = listByViewStreamController.stream;
          StreamSubscription<List<BukkungListModel>>? subscription;
          subscription = stream.listen((list) async {
            if (list.isNotEmpty) {
              final updatedList = list[0];
              selectedList(updatedList);
              // 리스트 레벨 가져오기
              UserModel? userData =
                  await UserRepository.getUserDataByUid(updatedList.userId!);
              final int? expPoint = userData!.expPoint;
              userLevel(
                  expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
              if (selectedList.value.likedUsers != null &&
                  selectedList.value.likedUsers!
                      .contains(AuthController.to.user.value.uid)) {
                isLiked(true);
              }
              subscription?.cancel();
            }
          });
        }
      case 3:
        {
          noMyList(false);
          final stream = favoriteListStreamController.stream;
          StreamSubscription<List<BukkungListModel>>? subscription;
          subscription = stream.listen((list) async {
            if (list.isNotEmpty) {
              noFavoriteList(false);
              final updatedList = list[0];
              selectedList(updatedList);
              // 리스트 레벨 가져오기
              UserModel? userData =
                  await UserRepository.getUserDataByUid(updatedList.userId!);
              final int? expPoint = userData!.expPoint;
              userLevel(
                  expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
              if (selectedList.value.likedUsers != null &&
                  selectedList.value.likedUsers!
                      .contains(AuthController.to.user.value.uid)) {
                isLiked(true);
              }
              subscription?.cancel();
            } else {
              //찜 리스트가 없을 경우
              print('진심 리스트 없어?');
              noFavoriteList(true);
            }
          });
        }
      case 4:
      default:
        {
          noFavoriteList(false);
          final stream = getSuggestionMyBukkungList();
          StreamSubscription<List<BukkungListModel>>? subscription;
          subscription = stream.listen((list) async {
            if (list.isNotEmpty) {
              noMyList(false);
              final updatedList = list[0];
              selectedList(updatedList);
              // 리스트 레벨 가져오기
              UserModel? userData =
                  await UserRepository.getUserDataByUid(updatedList.userId!);
              final int? expPoint = userData!.expPoint;
              userLevel(
                  expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
              if (selectedList.value.likedUsers != null &&
                  selectedList.value.likedUsers!
                      .contains(AuthController.to.user.value.uid)) {
                isLiked(true);
              }
              subscription?.cancel();
            } else {
              //내 리스트가 없을 경우
              noMyList(true);
            }
          });
        }
    }
  }

  void loadNewBukkungLists(String type) async {
    switch (type) {
      case 'like':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewSuggestionListByLike(
                  _pageSize, null, null, selectedCategories);
          listByLikeStreamController.add(firstList);
        }
      case 'date':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewSuggestionListByDate(
                  _pageSize, null, null, selectedCategories);
          listByDateStreamController.add(firstList);
        }
      case 'view':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewSuggestionListByView(
                  _pageSize, null, null, selectedCategories);
          listByViewStreamController.add(firstList);
        }
      case 'favorite':
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewFavoriteList(_pageSize, null, null, selectedCategories);
          favoriteListStreamController.add(firstList);
        }
      default:
        {
          List<BukkungListModel> firstList = await ListSuggestionRepository()
              .getNewSuggestionListByLike(
                  _pageSize, null, null, selectedCategories);
          listByLikeStreamController.add(firstList);
        }
    }
  }

  void loadMoreBukkungLists(String type) async {
    switch (type) {
      case 'like':
        {
          if (listByLikeScrollController.position.pixels >=
              listByLikeScrollController.position.maxScrollExtent * 0.7) {
            _paginationTimer.cancel();
            _paginationTimer = Timer(Duration(milliseconds: 200), () {});
            if (!isListByLikeLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewSuggestionListByLike(_pageSize, listByLikeKeyPage,
                      listByLikePrevList, selectedCategories);
              listByLikeStreamController.add(nextList);
            }
          }
        }
      case 'date':
        {
          // print(
          //     '${listByDateScrollController.position.pixels.toInt()} / ${(maxScroll)}');
          // print('개수 : ${listByDatePrevList!.length}');
          if (listByDateScrollController.position.pixels >=
              listByDateScrollController.position.maxScrollExtent * 0.7) {
            _paginationTimer.cancel();
            _paginationTimer = Timer(Duration(milliseconds: 200), () {});
            if (!isListByDateLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewSuggestionListByDate(_pageSize, listByDateKeyPage,
                      listByDatePrevList, selectedCategories);
              listByDateStreamController.add(nextList);
            }
          }
        }
      case 'view':
        {
          if (listByViewScrollController.position.pixels >=
              listByViewScrollController.position.maxScrollExtent * 0.7) {
            _paginationTimer.cancel();
            _paginationTimer = Timer(Duration(milliseconds: 200), () {});
            if (!isListByViewLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewSuggestionListByView(_pageSize, listByViewKeyPage,
                      listByViewPrevList, selectedCategories);
              listByViewStreamController.add(nextList);
            }
          }
        }
      case 'favorite':
        {
          if (favoriteListScrollController.position.pixels ==
              favoriteListScrollController.position.maxScrollExtent) {
            if (!isListByViewLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewFavoriteList(_pageSize, favoriteListKeyPage,
                      favoriteListPrevList, selectedCategories);
              favoriteListStreamController.add(nextList);
            }
          }
        }
      default:
        {
          if (listByLikeScrollController.position.pixels ==
              listByLikeScrollController.position.maxScrollExtent) {
            if (!isListByLikeLastPage) {
              List<BukkungListModel> nextList = await ListSuggestionRepository()
                  .getNewSuggestionListByLike(_pageSize, listByLikeKeyPage,
                      listByLikePrevList, selectedCategories);
              listByLikeStreamController.add(nextList);
            }
          }
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
    listByLikeScrollController.dispose();
    listByLikeStreamController.close();
    listByDateScrollController.dispose();
    listByDateStreamController.close();
    listByViewScrollController.dispose();
    listByViewStreamController.close();
    favoriteListScrollController.dispose();
    favoriteListStreamController.close();
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

  // String tabIndexToName(int tabIndex) {
  //   switch (tabIndex) {
  //     case 0:
  //       return 'all';
  //     case 1:
  //       return '1travel';
  //     case 2:
  //       return '2meal';
  //     case 3:
  //       return '3activity';
  //     case 4:
  //       return '4culture';
  //     case 5:
  //       return '5study';
  //     case 6:
  //       return '6etc';
  //     default:
  //       return 'all';
  //   }
  // }

  // Stream<List<BukkungListModel>> getSuggestionBukkungList(
  //   String category,
  // ) {
  //   // print('리스트 추천 stream(sugg cont) ${category}');
  //   if (category == 'all') {
  //     return ListSuggestionRepository().getAllBukkungList();
  //   } else {
  //     return ListSuggestionRepository().getCategoryBukkungList(category);
  //   }
  // }

  //리스트 선택
  void indexSelection(BukkungListModel updatedList) async {
    selectedList(updatedList);
    // selectedListIndex = index;
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
        //좋아요 해제
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
        //오프라인 리스트 업데이트(pagination)
        switch (suggestionListTabController.index) {
          case 0:
            int index = _findSelectedList(
                listByLikePrevList, selectedList.value.listId!);
            listByLikePrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByLikeStreamController.add(listByLikePrevList!);
          case 1:
            int index = _findSelectedList(
                listByDatePrevList, selectedList.value.listId!);
            listByDatePrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByDateStreamController.add(listByDatePrevList!);
          case 2:
            int index = _findSelectedList(
                listByViewPrevList, selectedList.value.listId!);
            listByViewPrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByViewStreamController.add(listByViewPrevList!);
          case 3:
            int index = _findSelectedList(
                favoriteListPrevList, selectedList.value.listId!);
            favoriteListPrevList![index].likeCount =
                selectedList.value.likeCount!;
            favoriteListStreamController.add(favoriteListPrevList!);
        }
        //화면 업데이트
        isLiked(false);
      } else {
        //좋아요 새로 누를때
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
        //오프라인 리스트 업데이트(pagination)
        switch (suggestionListTabController.index) {
          case 0:
            int index = _findSelectedList(
                listByLikePrevList, selectedList.value.listId!);
            listByLikePrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByLikeStreamController.add(listByLikePrevList!);
          case 1:
            int index = _findSelectedList(
                listByDatePrevList, selectedList.value.listId!);
            listByDatePrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByDateStreamController.add(listByDatePrevList!);
          case 2:
            int index = _findSelectedList(
                listByViewPrevList, selectedList.value.listId!);
            listByViewPrevList![index].likeCount =
                selectedList.value.likeCount!;
            listByViewStreamController.add(listByViewPrevList!);
          case 3:
            int index = _findSelectedList(
                favoriteListPrevList, selectedList.value.listId!);
            favoriteListPrevList![index].likeCount =
                selectedList.value.likeCount!;
            favoriteListStreamController.add(favoriteListPrevList!);
        }
        //화면 업데이트
        isLiked(true);
      }
    } else {
      //좋아요 누른 사람이 아무도 없을때(신규생성)
      // likedUsers가 null이면 새로운 리스트 생성 후 userId 추가
      // print('좋아요 null에서 추가(sug cont)');
      final updatedList = selectedList.value.copyWith(
        likeCount: selectedList.value.likeCount! + 1,
        likedUsers: [AuthController.to.user.value.uid!],
      );
      selectedList(updatedList);
      ListSuggestionRepository().updateLike(selectedList.value.listId!,
          selectedList.value.likeCount!, [AuthController.to.user.value.uid!]);
      //오프라인 리스트 업데이트(pagination)
      switch (suggestionListTabController.index) {
        case 0:
          int index =
              _findSelectedList(listByLikePrevList, selectedList.value.listId!);
          listByLikePrevList![index].likeCount = selectedList.value.likeCount!;
          listByLikeStreamController.add(listByLikePrevList!);
        case 1:
          int index =
              _findSelectedList(listByDatePrevList, selectedList.value.listId!);
          listByDatePrevList![index].likeCount = selectedList.value.likeCount!;
          listByDateStreamController.add(listByDatePrevList!);
        case 2:
          int index =
              _findSelectedList(listByViewPrevList, selectedList.value.listId!);
          listByViewPrevList![index].likeCount = selectedList.value.likeCount!;
          listByViewStreamController.add(listByViewPrevList!);
        case 3:
          int index = _findSelectedList(
              favoriteListPrevList, selectedList.value.listId!);
          favoriteListPrevList![index].likeCount =
              selectedList.value.likeCount!;
          favoriteListStreamController.add(favoriteListPrevList!);
      }
      //화면 업데이트
      isLiked(true);
    }
  }

  int _findSelectedList(List<BukkungListModel>? list, String listId) {
    if (list == null) return -1;
    int index = list.indexWhere((element) => element.listId == listId);
    return index;
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
      //오프라인 리스트 업데이트(pagination)
      switch (suggestionListTabController.index) {
        case 0:
          int index =
              _findSelectedList(listByLikePrevList, selectedList.value.listId!);
          listByLikePrevList![index].viewCount =
              selectedList.value.viewCount! + 1;
          listByLikeStreamController.add(listByLikePrevList!);
        case 1:
          int index =
              _findSelectedList(listByDatePrevList, selectedList.value.listId!);
          listByDatePrevList![index].viewCount =
              selectedList.value.viewCount! + 1;
          listByDateStreamController.add(listByDatePrevList!);
        case 2:
          int index =
              _findSelectedList(listByViewPrevList, selectedList.value.listId!);
          listByViewPrevList![index].viewCount =
              selectedList.value.viewCount! + 1;
          listByViewStreamController.add(listByViewPrevList!);
        case 3:
          int index = _findSelectedList(
              favoriteListPrevList, selectedList.value.listId!);
          favoriteListPrevList![index].viewCount =
              selectedList.value.viewCount! + 1;
          favoriteListStreamController.add(favoriteListPrevList!);
      }
    }
  }

  void setCopyCount() {
    var uuid = Uuid();
    String id = uuid.v1();
    CopyCountModel copyCountData = CopyCountModel(
      id: id,
      uid: AuthController.to.user.value.uid,
      listId: selectedList.value.listId,
      createdAt: DateTime.now(),
    );
    CopyCountRepository().uploadCopyCount(copyCountData);
    ListSuggestionRepository().addCopyCount(selectedList.value.listId!);
  }

  Future<void> listDelete() async {
    if (Constants.baseImageUrl != selectedList.value.imgUrl) {
      await ListSuggestionRepository()
          .deleteListImage('${selectedList.value.imgId!}.jpg');
    }
    CopyCountRepository().deleteCopyCountByListId(selectedList.value.listId!);
    ListSuggestionRepository().deleteList(
      selectedList.value.listId!,
    );
  }
}
