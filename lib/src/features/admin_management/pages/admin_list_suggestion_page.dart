// import 'package:couple_to_do_list_app/constants/constants.dart';
// import 'package:couple_to_do_list_app/features/admin_management/controller/admin_list_suggestion_page_controller.dart';
// import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
// import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
// import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
// import 'package:couple_to_do_list_app/utils/custom_color.dart';
// import 'package:couple_to_do_list_app/widgets/category_icon.dart';
// import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
// import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
// import 'package:couple_to_do_list_app/widgets/level_icon.dart';
// import 'package:couple_to_do_list_app/widgets/marquee_able_text.dart';
// import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
// import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class AdminListSuggestionPage
//     extends GetView<AdminListSuggestionPageController> {
//   const AdminListSuggestionPage({Key? key}) : super(key: key);
//
//   PreferredSizeWidget _appBar() {
//     return AppBar(
//       backgroundColor: CustomColors.mainPink,
//       leading: IconButton(
//         onPressed: () {
//           Get.back();
//         },
//         icon: Icon(
//           Icons.arrow_back_ios_new_rounded,
//           color: Colors.white,
//           size: 30,
//         ),
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Text(
//             '추천',
//             style: TextStyle(
//               fontWeight: FontWeight.w200,
//               color: Colors.white,
//               fontSize: 25,
//             ),
//           ),
//           Text(
//             ' 버꿍리스트',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: 25,
//             ),
//           )
//         ],
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: GestureDetector(
//             onTap: () {
//               Get.to(() => UploadBukkungListPage(), arguments: [null, true]);
//             },
//             child: Icon(
//               key: controller.adminAddKey,
//               Icons.add,
//               color: Colors.white,
//               size: 35,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _background() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
//         color: CustomColors.mainPink,
//       ),
//       height: 350,
//     );
//   }
//
//   Widget _searchBar() {
//     return Material(
//       type: MaterialType.transparency,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           color: Colors.white,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 50,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               child: Center(
//                 child: TextField(
//                   controller: controller.searchBarController,
//                   style: TextStyle(
//                     color: CustomColors.darkGrey,
//                     fontSize: 14,
//                   ),
//                   cursorColor: CustomColors.darkGrey,
//                   decoration: InputDecoration(
//                     hintText: '다양한 버꿍리스트를 찾아보세요',
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(
//                       color: CustomColors.grey.withOpacity(0.5),
//                       fontSize: 14,
//                     ),
//                     prefixIcon: Icon(
//                       Icons.search_rounded,
//                       size: 30,
//                       color: CustomColors.darkGrey,
//                     ),
//                     suffixIcon: controller.isTextEmpty
//                         ? null
//                         : IconButton(
//                             icon: Icon(
//                               Icons.close,
//                               size: 25,
//                               color: CustomColors.darkGrey,
//                             ),
//                             onPressed: () {
//                               return controller.searchBarController.clear();
//                             },
//                           ),
//                   ),
//                   onTap: () {
//                     controller.isSearchResult(true);
//                   },
//                   onEditingComplete: () {
//                     controller.isSearchResult(false);
//                   },
//                   onSubmitted: (_) {
//                     controller.isSearchResult(false);
//                   },
//                 ),
//               ),
//             ),
//             Obx(() {
//               if (controller.isSearchResult.value) {
//                 return GetBuilder<AdminListSuggestionPageController>(
//                   id: 'searchResult',
//                   builder: (AdminListSuggestionPageController) {
//                     return ConstrainedBox(
//                       constraints: BoxConstraints(maxHeight: 300),
//                       child: controller.isTextEmpty
//                           ? Center(
//                               child: Text('검색어를 입력하세요'),
//                             )
//                           : StreamBuilder(
//                               stream: controller.getSearchedBukkungList(),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<List<BukkungListModel>>
//                                       bukkungLists) {
//                                 if (!bukkungLists.hasData) {
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                         color: CustomColors.mainPink),
//                                   );
//                                 } else if (bukkungLists.hasError) {
//                                   openAlertDialog(title: '에러 발생');
//                                 } else {
//                                   final list = bukkungLists.data!;
//                                   return ListView(
//                                     physics: AlwaysScrollableScrollPhysics(),
//                                     children: [
//                                       Column(
//                                         children:
//                                             List.generate(list.length, (index) {
//                                           final bukkungList = list[index];
//                                           return _searchListCard(
//                                             bukkungList,
//                                             index,
//                                             context,
//                                           );
//                                         }),
//                                       ),
//                                     ],
//                                   );
//                                 }
//                                 return Center(child: Text('아직 버꿍리스트가 없습니다'));
//                               },
//                             ),
//                     );
//                   },
//                 );
//               }
//               return Container();
//             })
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _searchListCard(
//       BukkungListModel bukkungListModel, int index, BuildContext context) {
//     int? viewCount = bukkungListModel.viewCount;
//     NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
//     String formattedViewCount = formatter.format(viewCount);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
//       child: GestureDetector(
//         onTap: () {
//           // final updatedList = controller.selectedList.value.copyWith(
//           //   listId: bukkungListModel.listId,
//           //   title: bukkungListModel.title,
//           //   content: bukkungListModel.content,
//           //   location: bukkungListModel.location,
//           //   category: bukkungListModel.category,
//           //   imgUrl: bukkungListModel.imgUrl,
//           //   imgId: bukkungListModel.imgId,
//           //   madeBy: bukkungListModel.madeBy,
//           //   likedUsers: bukkungListModel.likedUsers,
//           //   likeCount: bukkungListModel.likeCount,
//           //   viewCount: bukkungListModel.viewCount,
//           // );
//           controller.indexSelection(bukkungListModel);
//           controller.viewCount();
//           controller.isSearchResult(false);
//           FocusScope.of(context).unfocus();
//         },
//         child: Container(
//           height: 85,
//           decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(
//                 color: CustomColors.darkGrey,
//                 width: 1,
//               )),
//           child: Row(
//             children: [
//               Container(
//                 width: 84,
//                 height: 84,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: CustomCachedNetworkImage(bukkungListModel.imgUrl!),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 10,
//                       offset: Offset(5, 5), // Offset(수평, 수직)
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 20),
//               SizedBox(
//                 width: 200,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(height: 10),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: PcText(
//                         bukkungListModel.title!,
//                         style: TextStyle(
//                             fontSize: 18, color: CustomColors.blackText),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _iconText(
//                             'location-pin.png',
//                             bukkungListModel.location ?? '',
//                             true,
//                           ),
//                           _iconText(
//                             'preview.png',
//                             '$formattedViewCount회',
//                             false,
//                           ),
//                           _iconText(
//                             null,
//                             '${bukkungListModel.likeCount.toString()}개',
//                             false,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _selectedImage() {
//     return Obx(() {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Stack(
//           children: [
//             controller.selectedList.value.imgUrl == null
//                 ? Container(
//                     width: Get.width - 50,
//                     height: 230,
//                     padding: const EdgeInsets.only(top: 400),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: CustomColors.mainPink,
//                       ),
//                     ),
//                   )
//                 : Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     width: Get.width - 50,
//                     height: 230,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: CustomCachedNetworkImage(
//                               controller.selectedList.value.imgUrl ?? ''),
//                           fit: BoxFit.cover),
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 3,
//                           blurRadius: 10,
//                           offset: Offset(5, 5), // Offset(수평, 수직)
//                         ),
//                       ],
//                     ),
//                   ),
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//               width: Get.width - 50,
//               height: 230,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(
//                 top: 30,
//                 left: 20,
//                 right: 20,
//                 bottom: 10,
//               ),
//               width: Get.width - 60,
//               height: 230,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: controller.selectedList.value.title == null
//                             ? Container()
//                             : Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   child: PcText(
//                                     controller.selectedList.value.title ?? '',
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                         fontSize: 24, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                       SizedBox(width: 10),
//                       Row(
//                         children: [
//                           CategoryIcon(
//                             category: controller.selectedList.value.category ??
//                                 '1travel',
//                             size: 25,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             controller.categoryToString[
//                                     controller.selectedList.value.category] ??
//                                 '',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Image.asset(
//                         'assets/icons/locationPinWhite.png',
//                         width: 20,
//                         color: Colors.white.withOpacity(0.9),
//                         colorBlendMode: BlendMode.modulate,
//                       ),
//                       Expanded(
//                         child: PcText(
//                           controller.selectedList.value.location ?? '',
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   BkText(
//                     controller.selectedList.value.content ?? '',
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 3,
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Row(
//                           children: [
//                             Text(
//                               'by: ${controller.selectedList.value.madeBy}',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: 15,
//                               ),
//                             ),
//                             SizedBox(width: 5),
//                             LevelIcon(level: controller.userLevel.value)
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           controller.toggleLike();
//                         },
//                         child: Icon(
//                           key: controller.adminLikeKey,
//                           controller.isLiked.value
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: Colors.white.withOpacity(0.9),
//                           size: 30,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _listPlayButton() {
//     return Positioned(
//       key: controller.adminCopyKey,
//       top: 340,
//       left: Get.width / 2 - 30,
//       child: CustomIconButton(
//         onTap: () {
//           Get.to(
//             () => UploadBukkungListPage(),
//             arguments: [controller.selectedList.value, true],
//           );
//         },
//         size: 60,
//         icon: Icon(
//           Icons.document_scanner,
//           size: 40,
//           color: Colors.white,
//         ),
//         shadowOffset: Offset(5, 5),
//         shadowBlurRadius: 5,
//       ),
//     );
//   }
//
//   Widget _suggestionListTabBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: TabBar(
//         isScrollable: false,
//         controller: controller.suggestionListTabController,
//         labelColor: Colors.black.withOpacity(0.8),
//         labelStyle: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w400,
//         ),
//         unselectedLabelStyle: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w200,
//           color: Colors.black.withOpacity(0.5),
//         ),
//         labelPadding: EdgeInsets.zero,
//         unselectedLabelColor: Colors.black.withOpacity(0.5),
//         indicator: UnderlineTabIndicator(
//             insets: EdgeInsets.only(left: 30, right: 30, bottom: 5),
//             borderSide: BorderSide(
//               width: 3,
//               color: Colors.black.withOpacity(0.5),
//             )),
//         tabs: const [
//           Tab(text: '인기'),
//           Tab(text: '최신'),
//           Tab(text: '조회수'),
//           Tab(text: '찜'),
//           Tab(text: '내 리스트'),
//         ],
//       ),
//     );
//   }
//
//   Widget _suggestionListTabView() {
//     return Expanded(
//       child: TabBarView(
//         controller: controller.suggestionListTabController,
//         children: [
//           _listByLike(),
//           _listByDate(),
//           _listByView(),
//           _favoriteList(),
//           _suggestionMyList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _listByLike() {
//     return StreamBuilder(
//       stream: controller.listByLikeStreamController.stream,
//       builder: (BuildContext context,
//           AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//         if (!bukkungLists.hasData) {
//           return Center(
//             child: CircularProgressIndicator(color: CustomColors.mainPink),
//           );
//         } else if (bukkungLists.hasError) {
//           openAlertDialog(title: '에러 발생');
//         } else {
//           final list = bukkungLists.data!;
//           return Scrollbar(
//             controller: controller.listByLikeScrollController,
//             thickness: 5,
//             thumbVisibility: true,
//             radius: Radius.circular(25),
//             child: ListView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: controller.listByLikeScrollController,
//               children: [
//                 SizedBox(height: 50),
//                 Column(
//                   children: List.generate(list.length, (index) {
//                     final bukkungList = list[index];
//                     return _suggestionListCard(bukkungList, index, false);
//                   }),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           );
//         }
//         return Center(child: Text('아직 추천리스트가 없습니다'));
//       },
//     );
//   }
//
//   Widget _listByDate() {
//     return StreamBuilder(
//       stream: controller.listByDateStreamController.stream,
//       builder: (BuildContext context,
//           AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//         if (!bukkungLists.hasData) {
//           return Center(
//             child: CircularProgressIndicator(color: CustomColors.mainPink),
//           );
//         } else if (bukkungLists.hasError) {
//           openAlertDialog(title: '에러 발생');
//         } else {
//           final list = bukkungLists.data!;
//           return Scrollbar(
//             controller: controller.listByDateScrollController,
//             thickness: 5,
//             thumbVisibility: true,
//             radius: Radius.circular(25),
//             child: ListView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: controller.listByDateScrollController,
//               children: [
//                 SizedBox(height: 50),
//                 Column(
//                   children: List.generate(list.length, (index) {
//                     final bukkungList = list[index];
//                     return _suggestionListCard(bukkungList, index, false);
//                   }),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           );
//         }
//         return Center(child: Text('아직 추천리스트가 없습니다'));
//       },
//     );
//   }
//
//   Widget _listByView() {
//     return StreamBuilder(
//       stream: controller.listByViewStreamController.stream,
//       builder: (BuildContext context,
//           AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//         if (!bukkungLists.hasData) {
//           return Center(
//             child: CircularProgressIndicator(color: CustomColors.mainPink),
//           );
//         } else if (bukkungLists.hasError) {
//           openAlertDialog(title: '에러 발생');
//         } else {
//           final list = bukkungLists.data!;
//           return Scrollbar(
//             controller: controller.listByViewScrollController,
//             thickness: 5,
//             thumbVisibility: true,
//             radius: Radius.circular(25),
//             child: ListView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: controller.listByViewScrollController,
//               children: [
//                 SizedBox(height: 50),
//                 Column(
//                   children: List.generate(list.length, (index) {
//                     final bukkungList = list[index];
//                     return _suggestionListCard(bukkungList, index, false);
//                   }),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           );
//         }
//         return Center(child: Text('아직 추천리스트가 없습니다'));
//       },
//     );
//   }
//
//   Widget _favoriteList() {
//     return StreamBuilder(
//       stream: controller.favoriteListStreamController.stream,
//       builder: (BuildContext context,
//           AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//         if (!bukkungLists.hasData) {
//           return Center(
//             child: CircularProgressIndicator(color: CustomColors.mainPink),
//           );
//         } else if (bukkungLists.hasError) {
//           openAlertDialog(title: '에러 발생');
//         } else {
//           final list = bukkungLists.data!;
//           return Scrollbar(
//             controller: controller.favoriteListScrollController,
//             thickness: 5,
//             thumbVisibility: true,
//             radius: Radius.circular(25),
//             child: ListView(
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: controller.favoriteListScrollController,
//               children: [
//                 SizedBox(height: 50),
//                 Column(
//                   children: List.generate(list.length, (index) {
//                     final bukkungList = list[index];
//                     return _suggestionListCard(bukkungList, index, false);
//                   }),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           );
//         }
//         return Center(child: Text('아직 좋아요를 누른 리스트가 없습니다'));
//       },
//     );
//   }
//
//   // Widget _suggestionCategoryList(int index) {
//   //   return StreamBuilder(
//   //     stream: controller.getSuggestionBukkungList(
//   //       controller.tabIndexToName(index),
//   //     ),
//   //     builder: (BuildContext context,
//   //         AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//   //       if (!bukkungLists.hasData) {
//   //         return Center(
//   //           child: CircularProgressIndicator(color: CustomColors.mainPink),
//   //         );
//   //       } else if (bukkungLists.hasError) {
//   //         openAlertDialog(title: '에러 발생');
//   //       } else {
//   //         final list = bukkungLists.data!;
//   //         return ListView(
//   //           physics: AlwaysScrollableScrollPhysics(),
//   //           children: [
//   //             SizedBox(height: 50),
//   //             Column(
//   //               children: List.generate(list.length, (index) {
//   //                 final bukkungList = list[index];
//   //                 return _suggestionListCard(bukkungList, index, false);
//   //               }),
//   //             ),
//   //             SizedBox(height: 20),
//   //           ],
//   //         );
//   //       }
//   //       return Center(child: Text('아직 버꿍리스트가 없습니다'));
//   //     },
//   //   );
//   // }
//
//   Widget _suggestionListCard(
//       BukkungListModel bukkungListModel, int index, bool isDelete) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: GestureDetector(
//         onTap: () {
//           controller.indexSelection(bukkungListModel);
//           controller.viewCount();
//         },
//         onDoubleTap: () {
//           Get.to(
//             () => UploadBukkungListPage(),
//             arguments: [controller.selectedList.value, true],
//           );
//         },
//         child: Stack(
//           children: [
//             Obx(() {
//               int? viewCount = bukkungListModel.viewCount;
//               NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
//               String formattedViewCount = formatter.format(viewCount);
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 padding: EdgeInsets.only(left: 120, right: 30),
//                 height: 85,
//                 decoration: BoxDecoration(
//                     color: bukkungListModel.listId ==
//                             controller.selectedList.value.listId
//                         ? CustomColors.lightPink.withOpacity(0.1)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(
//                       color: bukkungListModel.listId ==
//                               controller.selectedList.value.listId
//                           ? CustomColors.mainPink
//                           : Colors.white,
//                       width: 2,
//                     )),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(height: 10),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: PcText(
//                         bukkungListModel.title!,
//                         style: TextStyle(
//                             fontSize: 18, color: CustomColors.blackText),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     // Expanded(
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //     children: [
//                     //       _iconText(
//                     //         'location-pin.png',
//                     //         bukkungListModel.location ?? '',
//                     //         true,
//                     //       ),
//                     //       _iconText(
//                     //         'preview.png',
//                     //         '$formattedViewCount회',
//                     //         false,
//                     //       ),
//                     //       _iconText(
//                     //         null,
//                     //         '${bukkungListModel.likeCount.toString()}개',
//                     //         false,
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     Expanded(
//                       child: bukkungListModel.imgUrl == Constants.baseImageUrl
//                           ? CupertinoButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () async {
//                                 await controller
//                                     .updateAutoImage(bukkungListModel);
//                               },
//                               child: Text(
//                                 '사진 자동 추가',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: CustomCachedNetworkImage(bukkungListModel.imgUrl!),
//                     fit: BoxFit.cover),
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     offset: Offset(5, 5), // Offset(수평, 수직)
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: 0,
//               child: CustomIconButton(
//                 onTap: () {
//                   // final updatedList = controller.selectedList.value.copyWith(
//                   //   listId: bukkungListModel.listId,
//                   //   title: bukkungListModel.title,
//                   //   content: bukkungListModel.content,
//                   //   location: bukkungListModel.location,
//                   //   category: bukkungListModel.category,
//                   //   imgUrl: bukkungListModel.imgUrl,
//                   //   imgId: bukkungListModel.imgId,
//                   //   madeBy: bukkungListModel.madeBy,
//                   //   likedUsers: bukkungListModel.likedUsers,
//                   //   likeCount: bukkungListModel.likeCount,
//                   //   viewCount: bukkungListModel.viewCount,
//                   // );
//                   controller.indexSelection(bukkungListModel);
//                   openAlertDialog(
//                     title: '정말로 지우시겠습니까?',
//                     secondButtonText: '취소',
//                     mainfunction: () {
//                       controller.listDelete();
//                       Get.back();
//                     },
//                   );
//                 },
//                 size: 30,
//                 icon: Icon(
//                   Icons.delete_outline,
//                   size: 20,
//                   color: Colors.white,
//                 ),
//                 backgroundColor: CustomColors.redbrown,
//                 shadowBlurRadius: 2,
//                 shadowOffset: Offset(1, 1),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _iconText(String? image, String text, bool marquee) {
//     return Row(
//       children: [
//         image == null
//             ? Icon(
//                 Icons.favorite_border,
//                 size: 18,
//                 color: Colors.black.withOpacity(0.5),
//               )
//             : Image.asset(
//                 'assets/icons/$image',
//                 width: 20,
//                 color: CustomColors.grey.withOpacity(0.5),
//                 colorBlendMode: BlendMode.modulate,
//               ),
//         marquee
//             ? MarqueeAbleText(
//                 text: text,
//                 maxLength: 5,
//                 style: TextStyle(
//                   fontFamily: 'Bookk_mj',
//                   fontSize: 13,
//                 ),
//               )
//             : BkText(
//                 text,
//                 style: TextStyle(
//                   fontSize: 13,
//                 ),
//               ),
//       ],
//     );
//   }
//
//   Widget _suggestionMyList() {
//     return StreamBuilder(
//       stream: controller.getSuggestionMyBukkungList(),
//       builder: (BuildContext context,
//           AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
//         if (!bukkungLists.hasData) {
//           return Center(
//             child: CircularProgressIndicator(color: CustomColors.mainPink),
//           );
//         } else if (bukkungLists.hasError) {
//           openAlertDialog(title: '에러 발생');
//         } else {
//           final list = bukkungLists.data!;
//           return ListView(
//             physics: AlwaysScrollableScrollPhysics(),
//             children: [
//               SizedBox(height: 50),
//               Column(
//                 children: List.generate(list.length, (index) {
//                   final bukkungList = list[index];
//                   return _suggestionListCard(bukkungList, index, true);
//                 }),
//               ),
//               SizedBox(height: 20),
//             ],
//           );
//         }
//         return Center(child: Text('아직 버꿍리스트가 없습니다'));
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(AdminListSuggestionPageController(context));
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         controller.isSearchResult(false);
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: _appBar(),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 _background(),
//                 _suggestionListTabView(),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 75),
//                 // CategorySelectTabBar(
//                 //   tabController: controller.suggestionListTabController,
//                 //   selectedColor: Colors.black.withOpacity(0.8),
//                 //   unselectedColor: Colors.black.withOpacity(0.5),
//                 //   isMyTab: true,
//                 // ),
//                 _suggestionListTabBar(),
//                 _selectedImage(),
//               ],
//             ),
//             _listPlayButton(),
//             _searchBar(),
//           ],
//         ),
//       ),
//     );
//   }
// }
