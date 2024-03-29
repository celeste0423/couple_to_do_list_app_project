// import 'dart:async';
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/subjects.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
//
// class AdminListSuggestionPageController extends GetxController
//     with GetTickerProviderStateMixin {
//   final BuildContext context;
//   AdminListSuggestionPageController(this.context);
//   TutorialCoachMark? tutorialCoachMark;
//   List<TargetFocus> targets = [];
//
//   GlobalKey adminAddKey = GlobalKey();
//   GlobalKey adminLikeKey = GlobalKey();
//   GlobalKey adminCopyKey = GlobalKey();
//
//   late TabController suggestionListTabController;
//
//   static AdminListSuggestionPageController get to => Get.find();
//
//   TextEditingController searchBarController = TextEditingController();
//   List<String> _searchWord = [];
//   bool isTextEmpty = true;
//   Rx<bool> isSearchResult = false.obs;
//
//   Map<String, String> categoryToString = {
//     "1travel": "여행",
//     "2meal": "식사",
//     "3activity": "액티비티",
//     "4culture": "문화 활동",
//     "5study": "자기 계발",
//     "6etc": "기타",
//   };
//   Rx<bool> isLiked = false.obs;
//   Rx<int> userLevel = 0.obs;
//
//   Rx<BukkungListModel> selectedList = Rx<BukkungListModel>(BukkungListModel());
//   // int selectedListIndex = 0;
//
//   ScrollController listByLikeScrollController = ScrollController();
//   StreamController<List<BukkungListModel>> listByLikeStreamController =
//       BehaviorSubject<List<BukkungListModel>>();
//   QueryDocumentSnapshot<Map<String, dynamic>>? listByLikeKeyPage;
//   List<BukkungListModel>? listByLikePrevList;
//   bool isListByLikeLastPage = false;
//
//   ScrollController listByDateScrollController = ScrollController();
//   StreamController<List<BukkungListModel>> listByDateStreamController =
//       BehaviorSubject<List<BukkungListModel>>();
//   QueryDocumentSnapshot<Map<String, dynamic>>? listByDateKeyPage;
//   List<BukkungListModel>? listByDatePrevList;
//   bool isListByDateLastPage = false;
//
//   ScrollController listByViewScrollController = ScrollController();
//   StreamController<List<BukkungListModel>> listByViewStreamController =
//       BehaviorSubject<List<BukkungListModel>>();
//   QueryDocumentSnapshot<Map<String, dynamic>>? listByViewKeyPage;
//   List<BukkungListModel>? listByViewPrevList;
//   bool isListByViewLastPage = false;
//
//   ScrollController favoriteListScrollController = ScrollController();
//   StreamController<List<BukkungListModel>> favoriteListStreamController =
//       BehaviorSubject<List<BukkungListModel>>();
//   QueryDocumentSnapshot<Map<String, dynamic>>? favoriteListKeyPage;
//   List<BukkungListModel>? favoriteListPrevList;
//   bool isfavoriteListLastPage = false;
//
//   final int _pageSize = 5;
//
//   @override
//   void onInit() {
//     super.onInit();
//     suggestionListTabController = TabController(length: 5, vsync: this);
//     suggestionListTabController.addListener(() {
//       _onTabChanged();
//     });
//     searchBarController.addListener(onTextChanged);
//     _initSelectedBukkungList();
//     loadNewBukkungLists('like');
//     loadNewBukkungLists('date');
//     loadNewBukkungLists('view');
//     loadNewBukkungLists('favorite');
//     listByLikeScrollController.addListener(() {
//       loadMoreBukkungLists('like');
//     });
//     listByDateScrollController.addListener(() {
//       loadMoreBukkungLists('date');
//     });
//     listByViewScrollController.addListener(() {
//       loadMoreBukkungLists('view');
//     });
//     favoriteListScrollController.addListener(() {
//       loadMoreBukkungLists('favorite');
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       _showTutorialCoachMark();
//     });
//   }
//
//   void _showTutorialCoachMark() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasShownSuggestionTutorial =
//         prefs.getBool('hasShownSuggestionTutorial') ?? false;
//     if (hasShownSuggestionTutorial) {
//       //이미 튜토리얼을 진행했으면 튜토리얼 종료
//       return;
//     }
//     _initTarget(); //타겟 더하기
//     if (context.mounted) {
//       tutorialCoachMark = TutorialCoachMark(
//         targets: targets,
//         hideSkip: true,
//         onClickTarget: (target) {},
//       )..show(context: context);
//       await prefs.setBool('hasShownSuggestionTutorial', true);
//     }
//   }
//
//   void _initTarget() {
//     targets = [
//       TargetFocus(
//         identify: "add_key",
//         keyTarget: adminAddKey,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return CoachmarkDesc(
//                 text: "버튼을 눌러 나만의 버꿍리스트를 만들 수 있습니다.",
//                 onNext: () {
//                   controller.next();
//                 },
//                 onSkip: () {
//                   controller.skip();
//                 },
//               );
//             },
//           )
//         ],
//       ),
//       TargetFocus(
//         identify: "copy_key",
//         keyTarget: adminCopyKey,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return CoachmarkDesc(
//                 text: "마음에 드는 추천리스트가 있다면 우리의 버꿍리스트로 가져오세요!",
//                 onNext: () {
//                   controller.next();
//                 },
//                 onSkip: () {
//                   controller.skip();
//                 },
//               );
//             },
//           )
//         ],
//       ),
//       TargetFocus(
//         identify: "like_key",
//         keyTarget: adminLikeKey,
//         contents: [
//           TargetContent(
//             align: ContentAlign.bottom,
//             builder: (context, controller) {
//               return CoachmarkDesc(
//                 text: "잘 만든 것 같다면 좋아요 꾹!",
//                 onNext: () {
//                   controller.next();
//                 },
//                 onSkip: () {
//                   controller.skip();
//                 },
//               );
//             },
//           )
//         ],
//       ),
//     ];
//   }
//
//   void _onTabChanged() {
//     _initSelectedBukkungList();
//   }
//
//   void _initSelectedBukkungList() {
//     print(suggestionListTabController.index);
//     switch (suggestionListTabController.index) {
//       case 0:
//         {
//           print('인기 첫 리스트 선정');
//           final stream = listByLikeStreamController.stream;
//           StreamSubscription<List<BukkungListModel>>? subscription;
//           subscription = stream.listen((list) async {
//             if (list.isNotEmpty) {
//               final updatedList = list[0];
//               selectedList(updatedList);
//               // 리스트 레벨 가져오기
//               UserModel? userData =
//                   await UserRepository.getUserDataByUid(updatedList.userId!);
//               final int? expPoint = userData!.expPoint;
//               userLevel(
//                   expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
//               if (selectedList.value.likedUsers != null &&
//                   selectedList.value.likedUsers!
//                       .contains(AuthController.to.user.value.uid)) {
//                 isLiked(true);
//               }
//               subscription?.cancel();
//             }
//           });
//         }
//       case 1:
//         {
//           print('최신 첫 리스트 선정');
//           final stream = listByDateStreamController.stream;
//           StreamSubscription<List<BukkungListModel>>? subscription;
//           subscription = stream.listen((list) async {
//             if (list.isNotEmpty) {
//               final updatedList = list[0];
//               selectedList(updatedList);
//               // 리스트 레벨 가져오기
//               UserModel? userData =
//                   await UserRepository.getUserDataByUid(updatedList.userId!);
//               final int? expPoint = userData!.expPoint;
//               userLevel(
//                   expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
//               if (selectedList.value.likedUsers != null &&
//                   selectedList.value.likedUsers!
//                       .contains(AuthController.to.user.value.uid)) {
//                 isLiked(true);
//               }
//               subscription?.cancel();
//             }
//           });
//         }
//       case 2:
//         {
//           final stream = listByViewStreamController.stream;
//           StreamSubscription<List<BukkungListModel>>? subscription;
//           subscription = stream.listen((list) async {
//             if (list.isNotEmpty) {
//               final updatedList = list[0];
//               selectedList(updatedList);
//               // 리스트 레벨 가져오기
//               UserModel? userData =
//                   await UserRepository.getUserDataByUid(updatedList.userId!);
//               final int? expPoint = userData!.expPoint;
//               userLevel(
//                   expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
//               if (selectedList.value.likedUsers != null &&
//                   selectedList.value.likedUsers!
//                       .contains(AuthController.to.user.value.uid)) {
//                 isLiked(true);
//               }
//               subscription?.cancel();
//             }
//           });
//         }
//       case 3:
//         {
//           final stream = favoriteListStreamController.stream;
//           StreamSubscription<List<BukkungListModel>>? subscription;
//           subscription = stream.listen((list) async {
//             if (list.isNotEmpty) {
//               final updatedList = list[0];
//               selectedList(updatedList);
//               // 리스트 레벨 가져오기
//               UserModel? userData =
//                   await UserRepository.getUserDataByUid(updatedList.userId!);
//               final int? expPoint = userData!.expPoint;
//               userLevel(
//                   expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
//               if (selectedList.value.likedUsers != null &&
//                   selectedList.value.likedUsers!
//                       .contains(AuthController.to.user.value.uid)) {
//                 isLiked(true);
//               }
//               subscription?.cancel();
//             }
//           });
//         }
//       case 4:
//       //Todo: 굳이 선택될 필요가 있을까 근데..?
//       default:
//         {
//           final stream = listByLikeStreamController.stream;
//           StreamSubscription<List<BukkungListModel>>? subscription;
//           subscription = stream.listen((list) async {
//             if (list.isNotEmpty) {
//               final updatedList = list[0];
//               selectedList(updatedList);
//               // 리스트 레벨 가져오기
//               UserModel? userData =
//                   await UserRepository.getUserDataByUid(updatedList.userId!);
//               final int? expPoint = userData!.expPoint;
//               userLevel(
//                   expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
//               if (selectedList.value.likedUsers != null &&
//                   selectedList.value.likedUsers!
//                       .contains(AuthController.to.user.value.uid)) {
//                 isLiked(true);
//               }
//               subscription?.cancel();
//             }
//           });
//         }
//     }
//   }
//
//   void loadNewBukkungLists(String type) async {
//     switch (type) {
//       case 'like':
//         {
//           List<BukkungListModel> firstList =
//               await getNewSuggestionListByLike(_pageSize, null, null);
//           listByLikeStreamController.add(firstList);
//         }
//       case 'date':
//         {
//           List<BukkungListModel> firstList =
//               await getNewSuggestionListByDate(_pageSize, null, null);
//           listByDateStreamController.add(firstList);
//         }
//       case 'view':
//         {
//           List<BukkungListModel> firstList =
//               await getNewSuggestionListByView(_pageSize, null, null);
//           listByViewStreamController.add(firstList);
//         }
//       case 'favorite':
//         {
//           List<BukkungListModel> firstList =
//               await getNewFavoriteList(_pageSize, null, null);
//           favoriteListStreamController.add(firstList);
//         }
//       default:
//         {
//           List<BukkungListModel> firstList =
//               await getNewSuggestionListByLike(_pageSize, null, null);
//           listByLikeStreamController.add(firstList);
//         }
//     }
//   }
//
//   void loadMoreBukkungLists(String type) async {
//     switch (type) {
//       case 'like':
//         {
//           if (listByLikeScrollController.position.pixels ==
//               listByLikeScrollController.position.maxScrollExtent) {
//             if (!isListByLikeLastPage) {
//               List<BukkungListModel> nextList =
//                   await getNewSuggestionListByLike(
//                       _pageSize, listByLikeKeyPage, listByLikePrevList);
//               listByLikeStreamController.add(nextList);
//             }
//           }
//         }
//       case 'date':
//         {
//           if (listByDateScrollController.position.pixels ==
//               listByDateScrollController.position.maxScrollExtent) {
//             if (!isListByDateLastPage) {
//               List<BukkungListModel> nextList =
//                   await getNewSuggestionListByDate(
//                       _pageSize, listByDateKeyPage, listByDatePrevList);
//               listByDateStreamController.add(nextList);
//             }
//           }
//         }
//       case 'view':
//         {
//           if (listByViewScrollController.position.pixels ==
//               listByViewScrollController.position.maxScrollExtent) {
//             if (!isListByViewLastPage) {
//               List<BukkungListModel> nextList =
//                   await getNewSuggestionListByView(
//                       _pageSize, listByViewKeyPage, listByViewPrevList);
//               listByViewStreamController.add(nextList);
//             }
//           }
//         }
//       case 'favorite':
//         {
//           if (favoriteListScrollController.position.pixels ==
//               favoriteListScrollController.position.maxScrollExtent) {
//             if (!isListByViewLastPage) {
//               List<BukkungListModel> nextList =
//                   await getNewSuggestionListByView(
//                       _pageSize, favoriteListKeyPage, favoriteListPrevList);
//               favoriteListStreamController.add(nextList);
//             }
//           }
//         }
//       default:
//         {
//           if (listByLikeScrollController.position.pixels ==
//               listByLikeScrollController.position.maxScrollExtent) {
//             if (!isListByLikeLastPage) {
//               List<BukkungListModel> nextList =
//                   await getNewSuggestionListByLike(
//                       _pageSize, listByLikeKeyPage, listByLikePrevList);
//               listByLikeStreamController.add(nextList);
//             }
//           }
//         }
//     }
//   }
//
//   Future<List<BukkungListModel>> getNewSuggestionListByLike(
//     int pageSize,
//     QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
//     List<BukkungListModel>? prevList,
//   ) async {
//     Query<Map<String, dynamic>> query = FirebaseFirestore.instance
//         .collection('bukkungLists')
//         .orderBy('likeCount', descending: true)
//         .orderBy('createdAt', descending: true);
//     if (keyPage != null) {
//       query = query.startAfterDocument(keyPage);
//     }
//     query = query.limit(pageSize);
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
//     List<BukkungListModel> bukkungLists = prevList ?? [];
//     for (var bukkungList in querySnapshot.docs) {
//       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
//     }
//     //키페이지 설정
//     QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
//         querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
//     listByLikeKeyPage = lastDocument;
//     //이전 리스트 저장
//     listByLikePrevList = bukkungLists;
//     //마지막 페이지인지 여부 확인
//     if (querySnapshot.docs.length < pageSize) {
//       isListByLikeLastPage = true;
//     }
//     return bukkungLists;
//   }
//
//   Future<List<BukkungListModel>> getNewSuggestionListByDate(
//     int pageSize,
//     QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
//     List<BukkungListModel>? prevList,
//   ) async {
//     Query<Map<String, dynamic>> query = FirebaseFirestore.instance
//         .collection('bukkungLists')
//         .orderBy('createdAt', descending: true)
//         .orderBy('likeCount', descending: true);
//     if (keyPage != null) {
//       query = query.startAfterDocument(keyPage);
//     }
//     query = query.limit(pageSize);
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
//     List<BukkungListModel> bukkungLists = prevList ?? [];
//     for (var bukkungList in querySnapshot.docs) {
//       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
//     }
//     //키페이지 설정
//     QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
//         querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
//     listByDateKeyPage = lastDocument;
//     //이전 리스트 저장
//     listByDatePrevList = bukkungLists;
//     //마지막 페이지인지 여부 확인
//     if (querySnapshot.docs.length < pageSize) {
//       isListByDateLastPage = true;
//     }
//     return bukkungLists;
//   }
//
//   Future<List<BukkungListModel>> getNewSuggestionListByView(
//     int pageSize,
//     QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
//     List<BukkungListModel>? prevList,
//   ) async {
//     Query<Map<String, dynamic>> query = FirebaseFirestore.instance
//         .collection('bukkungLists')
//         .orderBy('viewCount', descending: true)
//         .orderBy('likeCount', descending: true)
//         .orderBy('createdAt', descending: true);
//     if (keyPage != null) {
//       query = query.startAfterDocument(keyPage);
//     }
//     query = query.limit(pageSize);
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
//     List<BukkungListModel> bukkungLists = prevList ?? [];
//     for (var bukkungList in querySnapshot.docs) {
//       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
//     }
//     //키페이지 설정
//     QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
//         querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
//     listByViewKeyPage = lastDocument;
//     //이전 리스트 저장
//     listByViewPrevList = bukkungLists;
//     //마지막 페이지인지 여부 확인
//     if (querySnapshot.docs.length < pageSize) {
//       isListByViewLastPage = true;
//     }
//     return bukkungLists;
//   }
//
//   Future<List<BukkungListModel>> getNewFavoriteList(
//     int pageSize,
//     QueryDocumentSnapshot<Map<String, dynamic>>? keyPage,
//     List<BukkungListModel>? prevList,
//   ) async {
//     String currentUserUid = AuthController.to.user.value.uid!;
//     Query<Map<String, dynamic>> query = FirebaseFirestore.instance
//         .collection('bukkungLists')
//         .where('likedUsers', arrayContains: currentUserUid)
//         .orderBy('likeCount', descending: true)
//         .orderBy('createdAt', descending: true);
//     if (keyPage != null) {
//       query = query.startAfterDocument(keyPage);
//     }
//     query = query.limit(pageSize);
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
//     List<BukkungListModel> bukkungLists = prevList ?? [];
//     for (var bukkungList in querySnapshot.docs) {
//       bukkungLists.add(BukkungListModel.fromJson(bukkungList.data()));
//     }
//     //키페이지 설정
//     QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument =
//         querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
//     favoriteListKeyPage = lastDocument;
//     //이전 리스트 저장
//     favoriteListPrevList = bukkungLists;
//     //마지막 페이지인지 여부 확인
//     if (querySnapshot.docs.length < pageSize) {
//       isfavoriteListLastPage = true;
//     }
//     return bukkungLists;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     suggestionListTabController.removeListener(() {
//       _onTabChanged;
//     });
//     suggestionListTabController.dispose();
//     searchBarController.dispose();
//     listByLikeScrollController.dispose();
//     listByLikeStreamController.close();
//     listByDateScrollController.dispose();
//     listByDateStreamController.close();
//     listByViewScrollController.dispose();
//     listByViewStreamController.close();
//     favoriteListScrollController.dispose();
//     favoriteListStreamController.close();
//   }
//
//   void onTextChanged() {
//     isTextEmpty = searchBarController.text.isEmpty;
//     _searchWord = searchBarController.text.split(' ');
//     isSearchResult(true);
//     update(['searchResult'], true);
//   }
//
//   Stream<List<BukkungListModel>> getSearchedBukkungList() {
//     return ListSuggestionRepository().getSearchedBukkungList(_searchWord);
//   }
//
//   // String tabIndexToName(int tabIndex) {
//   //   switch (tabIndex) {
//   //     case 0:
//   //       return 'all';
//   //     case 1:
//   //       return '1travel';
//   //     case 2:
//   //       return '2meal';
//   //     case 3:
//   //       return '3activity';
//   //     case 4:
//   //       return '4culture';
//   //     case 5:
//   //       return '5study';
//   //     case 6:
//   //       return '6etc';
//   //     default:
//   //       return 'all';
//   //   }
//   // }
//
//   // Stream<List<BukkungListModel>> getSuggestionBukkungList(
//   //   String category,
//   // ) {
//   //   // print('리스트 추천 stream(sugg cont) ${category}');
//   //   if (category == 'all') {
//   //     return ListSuggestionRepository().getAllBukkungList();
//   //   } else {
//   //     return ListSuggestionRepository().getCategoryBukkungList(category);
//   //   }
//   // }
//
//   Stream<List<BukkungListModel>> getSuggestionMyBukkungList() {
//     return ListSuggestionRepository().getMyBukkungList();
//   }
//
//   //리스트 선택
//   void indexSelection(BukkungListModel updatedList) async {
//     selectedList(updatedList);
//     // selectedListIndex = index;
//     if (selectedList.value.likedUsers != null &&
//         selectedList.value.likedUsers!
//             .contains(AuthController.to.user.value.uid)) {
//       // print('좋아요 있음 (sug cont)${selectedList.value.likedUsers}');
//       isLiked(true);
//     } else {
//       // print('좋아요 없음 (sug cont)');
//       isLiked(false);
//     }
//     int expPoint = 0;
//     UserModel? userData =
//         await UserRepository.getUserDataByUid(updatedList.userId!);
//     print('유저 exp${userData!.expPoint}');
//     if (userData.expPoint != null) {
//       expPoint = userData.expPoint!;
//     }
//     userLevel((expPoint - expPoint % 100) ~/ 100);
//     print('레벨${userLevel.value}');
//   }
//
//   void toggleLike() {
//     if (selectedList.value.likedUsers != null) {
//       if (selectedList.value.likedUsers!
//           .contains(AuthController.to.user.value.uid)) {
//         //좋아요 해제
//         // 이미 userId가 존재하면 userId 제거 후 likeCount 감소
//         // print('좋아요 감소(sug cont)');
//         selectedList.value.likedUsers!
//             .remove(AuthController.to.user.value.uid!);
//         final updatedList = selectedList.value.copyWith(
//           likeCount: selectedList.value.likeCount! - 1,
//           likedUsers: selectedList.value.likedUsers,
//         );
//         selectedList(updatedList);
//         ListSuggestionRepository().updateLike(
//           selectedList.value.listId!,
//           selectedList.value.likeCount!,
//           selectedList.value.likedUsers!,
//         );
//         //오프라인 리스트 업데이트(pagination)
//         switch (suggestionListTabController.index) {
//           case 0:
//             int index = _findSelectedList(
//                 listByLikePrevList, selectedList.value.listId!);
//             listByLikePrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByLikeStreamController.add(listByLikePrevList!);
//           case 1:
//             int index = _findSelectedList(
//                 listByDatePrevList, selectedList.value.listId!);
//             listByDatePrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByDateStreamController.add(listByDatePrevList!);
//           case 2:
//             int index = _findSelectedList(
//                 listByViewPrevList, selectedList.value.listId!);
//             listByViewPrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByViewStreamController.add(listByViewPrevList!);
//           case 3:
//             int index = _findSelectedList(
//                 favoriteListPrevList, selectedList.value.listId!);
//             favoriteListPrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             favoriteListStreamController.add(favoriteListPrevList!);
//         }
//         //화면 업데이트
//         isLiked(false);
//       } else {
//         //좋아요 새로 누를때
//         // userId가 존재하지 않으면 userId 추가 후 likeCount 증가
//         // print('좋아요 추가(sug cont)');
//         selectedList.value.likedUsers!.add(AuthController.to.user.value.uid!);
//         final updatedList = selectedList.value.copyWith(
//           likeCount: selectedList.value.likeCount! + 1,
//           likedUsers: selectedList.value.likedUsers,
//         );
//         selectedList(updatedList);
//         ListSuggestionRepository().updateLike(
//           selectedList.value.listId!,
//           selectedList.value.likeCount!,
//           selectedList.value.likedUsers!,
//         );
//         //오프라인 리스트 업데이트(pagination)
//         switch (suggestionListTabController.index) {
//           case 0:
//             int index = _findSelectedList(
//                 listByLikePrevList, selectedList.value.listId!);
//             listByLikePrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByLikeStreamController.add(listByLikePrevList!);
//           case 1:
//             int index = _findSelectedList(
//                 listByDatePrevList, selectedList.value.listId!);
//             listByDatePrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByDateStreamController.add(listByDatePrevList!);
//           case 2:
//             int index = _findSelectedList(
//                 listByViewPrevList, selectedList.value.listId!);
//             listByViewPrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             listByViewStreamController.add(listByViewPrevList!);
//           case 3:
//             int index = _findSelectedList(
//                 favoriteListPrevList, selectedList.value.listId!);
//             favoriteListPrevList![index].likeCount =
//                 selectedList.value.likeCount!;
//             favoriteListStreamController.add(favoriteListPrevList!);
//         }
//         //화면 업데이트
//         isLiked(true);
//       }
//     } else {
//       //좋아요 누른 사람이 아무도 없을때(신규생성)
//       // likedUsers가 null이면 새로운 리스트 생성 후 userId 추가
//       // print('좋아요 null에서 추가(sug cont)');
//       final updatedList = selectedList.value.copyWith(
//         likeCount: selectedList.value.likeCount! + 1,
//         likedUsers: [AuthController.to.user.value.uid!],
//       );
//       selectedList(updatedList);
//       ListSuggestionRepository().updateLike(selectedList.value.listId!,
//           selectedList.value.likeCount!, [AuthController.to.user.value.uid!]);
//       //오프라인 리스트 업데이트(pagination)
//       switch (suggestionListTabController.index) {
//         case 0:
//           int index =
//               _findSelectedList(listByLikePrevList, selectedList.value.listId!);
//           listByLikePrevList![index].likeCount = selectedList.value.likeCount!;
//           listByLikeStreamController.add(listByLikePrevList!);
//         case 1:
//           int index =
//               _findSelectedList(listByDatePrevList, selectedList.value.listId!);
//           listByDatePrevList![index].likeCount = selectedList.value.likeCount!;
//           listByDateStreamController.add(listByDatePrevList!);
//         case 2:
//           int index =
//               _findSelectedList(listByViewPrevList, selectedList.value.listId!);
//           listByViewPrevList![index].likeCount = selectedList.value.likeCount!;
//           listByViewStreamController.add(listByViewPrevList!);
//         case 3:
//           int index = _findSelectedList(
//               favoriteListPrevList, selectedList.value.listId!);
//           favoriteListPrevList![index].likeCount =
//               selectedList.value.likeCount!;
//           favoriteListStreamController.add(favoriteListPrevList!);
//       }
//       //화면 업데이트
//       isLiked(true);
//     }
//   }
//
//   int _findSelectedList(List<BukkungListModel>? list, String listId) {
//     if (list == null) return -1;
//     int index = list.indexWhere((element) => element.listId == listId);
//     return index;
//   }
//
//   void viewCount() {
//     // print(
//     //     '${selectedList.value.userId},${AuthController.to.group.value.femaleUid}');
//     if (selectedList.value.userId != AuthController.to.group.value.femaleUid &&
//         selectedList.value.userId != AuthController.to.group.value.maleUid) {
//       // print(
//       //     '${selectedList.value.userId},${AuthController.to.group.value.maleUid}');
//       ListSuggestionRepository().updateViewCount(
//         selectedList.value.listId!,
//         selectedList.value.viewCount! + 1,
//       );
//       //오프라인 리스트 업데이트(pagination)
//       switch (suggestionListTabController.index) {
//         case 0:
//           int index =
//               _findSelectedList(listByLikePrevList, selectedList.value.listId!);
//           listByLikePrevList![index].viewCount =
//               selectedList.value.viewCount! + 1;
//           listByLikeStreamController.add(listByLikePrevList!);
//         case 1:
//           int index =
//               _findSelectedList(listByDatePrevList, selectedList.value.listId!);
//           listByDatePrevList![index].viewCount =
//               selectedList.value.viewCount! + 1;
//           listByDateStreamController.add(listByDatePrevList!);
//         case 2:
//           int index =
//               _findSelectedList(listByViewPrevList, selectedList.value.listId!);
//           listByViewPrevList![index].viewCount =
//               selectedList.value.viewCount! + 1;
//           listByViewStreamController.add(listByViewPrevList!);
//         case 3:
//           int index = _findSelectedList(
//               favoriteListPrevList, selectedList.value.listId!);
//           favoriteListPrevList![index].viewCount =
//               selectedList.value.viewCount! + 1;
//           favoriteListStreamController.add(favoriteListPrevList!);
//       }
//     }
//   }
//
//   Future<void> listDelete() async {
//     if (Constants.baseImageUrl != selectedList.value.imgUrl) {
//       await ListSuggestionRepository()
//           .deleteListImage('${selectedList.value.imgId!}.jpg');
//     }
//     ListSuggestionRepository().deleteList(
//       selectedList.value.listId!,
//     );
//   }
//
//   Future<void> updateAutoImage(BukkungListModel bukkungListData) async {
//     try {
//       // Query를 실행하여 listId가 일치하는 모든 bukkungList를 가져옵니다.
//       QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//           .instance
//           .collectionGroup('bukkungLists')
//           .where('listId', isEqualTo: bukkungListData.listId)
//           .get();
//       // 가져온 각각의 문서에 대해 업데이트를 수행합니다.
//       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
//         // 업데이트를 수행할 문서의 참조를 가져옵니다.
//         DocumentReference documentReference = doc.reference;
//         String? updatedImgUrl = await getOnlineImage(bukkungListData.title!);
//         if (updatedImgUrl != null) {
//           // 업데이트할 데이터를 작성합니다.
//           Map<String, dynamic> updatedData = {
//             'imgUrl': updatedImgUrl,
//           };
//           // 문서를 업데이트합니다.
//           await documentReference.update(updatedData);
//         }
//       }
//       print('업데이트가 완료되었습니다.');
//     } catch (e) {
//       print('업데이트 중 오류가 발생했습니다: $e');
//     }
//   }
//
//   Future<String?> getOnlineImage(String searchWords) async {
//     final response = await http.get(
//       Uri.parse(
//           "https://api.pexels.com/v1/search?query=$searchWords&locale=ko-KR&per_page=1"),
//       headers: {
//         'Authorization':
//             'vj40CWvim48eP6I6ymW21oHCbU50DVS4Dyj8y4b4GZVIKaWaT9EisapB'
//       },
//     );
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       // 안전하게 null 체크를 수행하고 photos가 없으면 null을 반환
//       List<dynamic>? photos = data['photos'];
//       if (photos == null || photos.isEmpty) {
//         return null;
//       }
//       Map<String, dynamic>? firstPhoto = photos[0];
//       if (firstPhoto == null) {
//         return null;
//       }
//       String? originalImageUrl = firstPhoto['src']['original'];
//       return originalImageUrl;
//     } else {
//       // 오류가 발생한 경우에도 null 반환
//       print('추천 사진 없음 오류 (upl buk cont)');
//       return null;
//     }
//   }
// }
