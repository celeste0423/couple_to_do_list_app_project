import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/src/features/read_suggestion_list/pages/read_suggestion_list_page.dart';
import 'package:couple_to_do_list_app/src/features/suggestion_list/controller/suggestion_list_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/src/helper/analytics.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/src/widgets/marquee_able_text.dart';
import 'package:couple_to_do_list_app/src/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/src/widgets/text/PcText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class SuggestionListPage extends GetView<SuggestionListPageController> {
  const SuggestionListPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.mainPink,
      // leading: IconButton(
      //   onPressed: () {
      //     Get.back();
      //   },
      //   icon: Icon(
      //     Icons.arrow_back_ios_new_rounded,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      // ),
      leading: SizedBox(
        width: 30,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '추천',
            style: TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Text(
            ' 버꿍리스트',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          )
        ],
      ),
      actions: const [
        SizedBox(width: 40),
      ],
    );
  }

  Widget _background() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
        color: CustomColors.mainPink,
      ),
      height: 350,
    );
  }

  Widget _searchBar() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Center(
                child: TextField(
                  controller: controller.searchBarController,
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 14,
                  ),
                  cursorColor: CustomColors.darkGrey,
                  decoration: InputDecoration(
                    hintText: '다양한 버꿍리스트를 찾아보세요',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: CustomColors.grey.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 30,
                      color: CustomColors.darkGrey,
                    ),
                    suffixIcon: controller.isTextEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                              color: CustomColors.darkGrey,
                            ),
                            onPressed: () {
                              return controller.searchBarController.clear();
                            },
                          ),
                  ),
                  onTap: () {
                    controller.isSearchResult(true);
                  },
                  onEditingComplete: () {
                    controller.isSearchResult(false);
                  },
                  onSubmitted: (_) {
                    controller.isSearchResult(false);
                  },
                ),
              ),
            ),
            Obx(() {
              if (controller.isSearchResult.value) {
                // print('출력물 ${controller.isSearchResult.value}');
                return GetBuilder<SuggestionListPageController>(
                  id: 'searchResult',
                  builder: (ListSuggestionPageController) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: controller.isTextEmpty
                          ? Center(
                              child: Text('검색어를 입력하세요'),
                            )
                          : StreamBuilder(
                              stream: controller.getSearchedBukkungList(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<BukkungListModel>>
                                      bukkungLists) {
                                if (!bukkungLists.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: CustomColors.mainPink),
                                  );
                                } else if (bukkungLists.hasError) {
                                  openAlertDialog(title: '에러 발생');
                                } else {
                                  final list = bukkungLists.data!;
                                  return ListView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: [
                                      Column(
                                        children:
                                            List.generate(list.length, (index) {
                                          final bukkungList = list[index];
                                          return _searchListCard(
                                            bukkungList,
                                            index,
                                            context,
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                }
                                return Center(child: Text('아직 버꿍리스트가 없습니다'));
                              },
                            ),
                    );
                  },
                );
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }

  Widget _searchListCard(
      BukkungListModel bukkungListModel, int index, BuildContext context) {
    int? viewCount = bukkungListModel.viewCount;
    NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
    String formattedViewCount = formatter.format(viewCount);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: GestureDetector(
        onTap: () {
          //상세 페이지 이동
          Analytics().logEvent('suggestion_searched_bukkunglist_read', null);
          Get.to(
            () => ReadSuggestionListPage(),
            arguments: bukkungListModel,
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500),
          );
        },
        child: Container(
          height: 85,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: CustomColors.darkGrey,
                width: 1,
              )),
          child: Row(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(bukkungListModel.imgUrl!),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(5, 5), // Offset(수평, 수직)
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: PcText(
                        bukkungListModel.title!,
                        style: TextStyle(
                            fontSize: 18, color: CustomColors.blackText),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconText(
                            'location-pin.png',
                            bukkungListModel.location ?? '',
                            true,
                          ),
                          _iconText(
                            'preview.png',
                            '$formattedViewCount회',
                            false,
                          ),
                          _iconText(
                            'likeCount',
                            '${bukkungListModel.likeCount.toString()}개',
                            false,
                          ),
                          _iconText(
                            'copyCount',
                            '${bukkungListModel.copyCount.toString()}회',
                            false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestionListTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return _categorySelectDialog();
          //       },
          //     );
          //   },
          //   child: Container(
          //     width: 35,
          //     height: 35,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(25),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 3, bottom: 5),
          //       child: PngIcon(
          //         iconName: 'category',
          //         iconColor: Colors.black.withOpacity(0.6),
          //         iconSize: 25,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: TabBar(
              isScrollable: false,
              dividerColor: Colors.transparent,
              controller: controller.suggestionListTabController,
              labelColor: Colors.black.withOpacity(0.8),
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Colors.black.withOpacity(0.5),
              ),
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: Colors.black.withOpacity(0.5),
              indicator: UnderlineTabIndicator(
                insets: EdgeInsets.only(left: 30, right: 30, bottom: 5),
                borderSide: BorderSide(
                  width: 3,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              tabs: const [
                Tab(text: '최신'),
                Tab(text: '인기'),
                // Tab(text: '조회수'),
                Tab(text: '내 리스트'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _categorySelectDialog() {
  //   return AlertDialog(
  //     title: Text('카테고리를 선택해주세요'),
  //     content: SingleChildScrollView(
  //       child: Obx(
  //         () => Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: controller.categories.map((item) {
  //             //print(controller.selectedCategories);
  //             return CheckboxListTile(
  //               title: Text(controller.categoryToString[item]!),
  //               value: controller.selectedCategories.contains(item),
  //               activeColor: CustomColors.mainPink,
  //               onChanged: (bool? value) {
  //                 if (value!) {
  //                   controller.selectedCategories.add(item);
  //                 } else {
  //                   controller.selectedCategories.remove(item);
  //                 }
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () {
  //           controller.selectedCategories.clear();
  //           Get.back();
  //         },
  //         child: Text(
  //           '취소',
  //           style: TextStyle(
  //             color: CustomColors.blackText,
  //           ),
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           controller.listByLikePrevList!.clear();
  //           controller.listByDatePrevList!.clear();
  //           controller.listByViewPrevList!.clear();
  //           controller.loadNewBukkungLists('like');
  //           controller.loadNewBukkungLists('date');
  //           controller.loadNewBukkungLists('view');
  //           controller.loadNewBukkungLists('favorite');
  //           Get.back();
  //         },
  //         child: Text(
  //           '확인',
  //           style: TextStyle(
  //             color: CustomColors.mainPink,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _suggestionListTabView() {
    return Expanded(
      child: TabBarView(
        controller: controller.suggestionListTabController,
        children: [
          _listViewByDate(),
          _listViewByCopy(),
          _listViewMy(),
        ],
      ),
    );
  }

  // List<Widget> _listView() {
  //   return List.generate(
  //     3,
  //     (tabIndex) {
  //       print('탭이야 ${tabIndex}')
  //       return PagedListView(
  //         scrollController: controller.listScrollController[tabIndex],
  //         pagingController: controller.listPagingController[tabIndex],
  //         builderDelegate: PagedChildBuilderDelegate<
  //             QueryDocumentSnapshot<Map<String, dynamic>>>(
  //           itemBuilder: (context, suggestionListMap, index) {
  //             print('인덱스 ${tabIndex} 길이 ${index}');
  //             return _suggestionListCard(
  //               BukkungListModel.fromJson(suggestionListMap.data()),
  //               index,
  //               tabIndex == 2,
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _listViewByDate() {
    return PagedListView(
      scrollController: controller.listScrollControllerByDate,
      pagingController: controller.listPagingControllerByDate,
      builderDelegate: PagedChildBuilderDelegate<
          QueryDocumentSnapshot<Map<String, dynamic>>>(
        itemBuilder: (context, suggestionListMap, index) {
          return _suggestionListCard(
            BukkungListModel.fromJson(suggestionListMap.data()),
            index,
            false,
          );
        },
      ),
    );
  }

  Widget _listViewByCopy() {
    return PagedListView(
      scrollController: controller.listScrollControllerByCopy,
      pagingController: controller.listPagingControllerByCopy,
      builderDelegate: PagedChildBuilderDelegate<
          QueryDocumentSnapshot<Map<String, dynamic>>>(
        itemBuilder: (context, suggestionListMap, index) {
          return _suggestionListCard(
            BukkungListModel.fromJson(suggestionListMap.data()),
            index,
            false,
          );
        },
      ),
    );
  }

  Widget _listViewMy() {
    return PagedListView(
      scrollController: controller.listScrollControllerMy,
      pagingController: controller.listPagingControllerMy,
      builderDelegate: PagedChildBuilderDelegate<
          QueryDocumentSnapshot<Map<String, dynamic>>>(
        itemBuilder: (context, suggestionListMap, index) {
          return _suggestionListCard(
            BukkungListModel.fromJson(suggestionListMap.data()),
            index,
            true,
          );
        },
      ),
    );
  }

  Widget _suggestionListCard(
    BukkungListModel bukkungListModel,
    int index,
    bool isDelete,
  ) {
    // print('이름 ${bukkungListModel.title}');
    int? viewCount = bukkungListModel.viewCount;
    NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
    String formattedViewCount = formatter.format(viewCount);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: CupertinoButton(
        onPressed: () {
          Analytics().logEvent('suggestion_bukkunglist_read', null);
          controller.addViewCount(bukkungListModel);
          //세부 페이지 이동
          Get.to(
            () => ReadSuggestionListPage(),
            arguments: bukkungListModel,
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500),
          );
        },
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 110, right: 30),
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: PcText(
                      bukkungListModel.title!,
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.blackText,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconText(
                          'location-pin.png',
                          bukkungListModel.location ?? '',
                          true,
                        ),
                        _iconText(
                          'preview.png',
                          '$formattedViewCount회',
                          false,
                        ),
                        _iconText(
                          'copyCount',
                          '${bukkungListModel.copyCount.toString()}회',
                          false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(5, 5), // Offset(수평, 수직)
                  ),
                ],
                image: DecorationImage(
                  image: CustomCachedNetworkImage(bukkungListModel.imgUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isDelete)
              Positioned(
                right: 0,
                child: CustomIconButton(
                  onTap: () {
                    openAlertDialog(
                      title: '정말로 지우시겠습니까?',
                      secondButtonText: '취소',
                      mainfunction: () {
                        controller.listDelete(bukkungListModel);
                        Get.back();
                      },
                    );
                  },
                  size: 30,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                  backgroundColor: CustomColors.redbrown,
                  shadowBlurRadius: 2,
                  shadowOffset: Offset(1, 1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconText(String? image, String text, bool marquee) {
    return Row(
      children: [
        image == 'likeCount'
            ? Icon(
                Icons.favorite_border,
                size: 16,
                color: Colors.black.withOpacity(0.5),
              )
            : image == 'copyCount'
                ? Icon(
                    Icons.document_scanner_outlined,
                    size: 16,
                    color: Colors.black.withOpacity(0.5),
                  )
                : Image.asset(
                    'assets/icons/$image',
                    width: 18,
                    color: CustomColors.grey.withOpacity(0.5),
                    colorBlendMode: BlendMode.modulate,
                  ),
        marquee
            ? MarqueeAbleText(
                text: text,
                maxLength: 5,
                style: TextStyle(
                  fontFamily: 'Bookk_mj',
                  fontSize: 11,
                  color: CustomColors.blackText,
                ),
              )
            : BkText(
                text,
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors.blackText,
                ),
              ),
      ],
    );
  }

  // Widget _suggestionMyList() {
  //   return StreamBuilder(
  //     stream: controller.getSuggestionMyBukkungList(),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
  //       if (!bukkungLists.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(color: CustomColors.mainPink),
  //         );
  //       } else if (bukkungLists.hasError) {
  //         openAlertDialog(title: '에러 발생');
  //       } else {
  //         final list = bukkungLists.data!;
  //         return ListView(
  //           physics: AlwaysScrollableScrollPhysics(),
  //           children: [
  //             SizedBox(height: 50),
  //             Column(
  //               children: List.generate(list.length, (index) {
  //                 final bukkungList = list[index];
  //                 return _suggestionListCard(bukkungList, index, true);
  //               }),
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         );
  //       }
  //       return Center(child: Text('아직 버꿍리스트가 없습니다'));
  //     },
  //   );
  // }

  Widget _listAddButton() {
    return FloatingActionButton(
      onPressed: () {
        Analytics().logEvent('made_new_bukkunglist', null);
        Get.to(() => UploadBukkungListPage(), arguments: [null, true]);
      },
      backgroundColor: CustomColors.mainPink,
      child: Icon(
        // key: controller.addKey,
        Icons.add,
        color: Colors.white,
        size: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SuggestionListPageController());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.isSearchResult(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: Stack(
          children: [
            _background(),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: 75),
              _suggestionListTabBar(context),
              _suggestionListTabView(),
            ]),
            _searchBar(),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90, right: 10),
          child: _listAddButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
