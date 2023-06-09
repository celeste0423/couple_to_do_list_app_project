import 'package:couple_to_do_list_app/features/list_suggestion/controller/list_suggestion_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_select_tab_bar.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/widgets/marquee_able_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListSuggestionPage extends GetView<ListSuggestionPageController> {
  const ListSuggestionPage({Key? key}) : super(key: key);

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
    return Hero(
      tag: 'search_bar',
      child: Material(
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: controller.searchBarController,
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontFamily: 'Yoonwoo',
                    fontSize: 20,
                  ),
                  cursorColor: CustomColors.darkGrey,
                  decoration: InputDecoration(
                    hintText: '다양한 버꿍리스트를 찾아보세요',
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 35,
                      color: CustomColors.darkGrey,
                    ),
                    suffixIcon: controller.isTextEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
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
              Obx(() {
                if (controller.isSearchResult.value) {
                  return GetBuilder<ListSuggestionPageController>(
                    id: 'searchResult',
                    builder: (ListSuggestionPageController) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: StreamBuilder(
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
                                          bukkungList, index, context);
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
          final updatedList = controller.selectedList.value.copyWith(
            listId: bukkungListModel.listId,
            title: bukkungListModel.title,
            content: bukkungListModel.content,
            location: bukkungListModel.location,
            category: bukkungListModel.category,
            imgUrl: bukkungListModel.imgUrl,
            imgId: bukkungListModel.imgId,
            madeBy: bukkungListModel.madeBy,
            likedUsers: bukkungListModel.likedUsers,
            likeCount: bukkungListModel.likeCount,
            viewCount: bukkungListModel.viewCount,
          );
          controller.indexSelection(updatedList, index);
          controller.viewCount();
          controller.isSearchResult(false);
          FocusScope.of(context).unfocus();
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
                    image: NetworkImage(bukkungListModel.imgUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeAbleText(
                    text: bukkungListModel.title!,
                    maxLength: 13,
                    style:
                        TextStyle(fontSize: 25, color: CustomColors.blackText),
                  ),
                  SizedBox(height: 20),
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
                          null,
                          '${bukkungListModel.likeCount.toString()}개',
                          false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedImage() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            controller.selectedList.value.imgUrl == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 400),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.mainPink,
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: Get.width - 60,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(5, 5), // Offset(수평, 수직)
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                            controller.selectedList.value.imgUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: Get.width - 60,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              width: Get.width - 60,
              height: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/locationPinWhite.png',
                        width: 35,
                        color: Colors.white.withOpacity(0.9),
                        colorBlendMode: BlendMode.modulate,
                      ),
                      Expanded(
                        child: Text(
                          controller.selectedList.value.location ?? '',
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    controller.selectedList.value.content ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'by: ${controller.selectedList.value.madeBy}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.toggleLike();
                        },
                        child: Icon(
                          controller.isLiked.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white.withOpacity(0.9),
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _listPlayButton() {
    return Positioned(
      top: 340,
      left: Get.width / 2 - 30,
      child: CustomIconButton(
        onTap: () {
          Get.to(() => UploadBukkungListPage(),
              arguments: controller.selectedList.value);
        },
        size: 60,
        icon: Icon(
          Icons.play_arrow_rounded,
          size: 60,
          color: Colors.white,
        ),
        shadowOffset: Offset(5, 5),
        shadowBlurRadius: 5,
      ),
    );
  }

  Widget _suggestionListTab() {
    return Expanded(
      child: TabBarView(
        controller: controller.suggestionListTabController,
        children: [
          _suggestionTestList(0),
          _suggestionList(1),
          _suggestionList(2),
          _suggestionList(3),
          _suggestionList(4),
          _suggestionList(5),
          _suggestionList(6),
          _suggestionMyList(),
        ],
      ),
    );
  }

  // Widget _suggestionTest1List() {
  //   return RefreshIndicator(
  //     onRefresh: () => Future.sync(
  //       () => controller.pagingController.refresh(),
  //     ),
  //     child: PagedListView(
  //       physics: AlwaysScrollableScrollPhysics(),
  //       padding: const EdgeInsets.only(top: 400, bottom: 20),
  //       scrollController: controller.suggestionListScrollController,
  //       pagingController: controller.pagingController,
  //       builderDelegate: PagedChildBuilderDelegate<
  //           QueryDocumentSnapshot<Map<String, dynamic>>>(
  //         itemBuilder: (context, snapshots, index) {
  //           QueryDocumentSnapshot<Map<String, dynamic>> snapshot = snapshots;
  //           BukkungListModel bukkungList =
  //               BukkungListModel.fromJson(snapshot.data());
  //           return _suggestionListCard(bukkungList, index, false);
  //         },
  //         noItemsFoundIndicatorBuilder: (context) => Center(
  //           child: Text('아직 리스트가 없습니다'),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _suggestionTestList(int index) {
    return StreamBuilder(
      stream: controller.streamController.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
        if (!bukkungLists.hasData) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.mainPink),
          );
        } else if (bukkungLists.hasError) {
          openAlertDialog(title: '에러 발생');
        } else {
          final list = bukkungLists.data!;
          return Scrollbar(
            controller: controller.suggestionListScrollController,
            thickness: 5,
            thumbVisibility: true,
            radius: Radius.circular(25),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller.suggestionListScrollController,
              children: [
                SizedBox(height: 50),
                Column(
                  children: List.generate(list.length, (index) {
                    final bukkungList = list[index];
                    return _suggestionListCard(bukkungList, index, false);
                  }),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }
        return Center(child: Text('아직 버꿍리스트가 없습니다'));
      },
    );
  }

  Widget _suggestionList(int index) {
    return StreamBuilder(
      stream: controller.getSuggestionBukkungList(
        controller.tabIndexToName(index),
      ),
      builder: (BuildContext context,
          AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
        if (!bukkungLists.hasData) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.mainPink),
          );
        } else if (bukkungLists.hasError) {
          openAlertDialog(title: '에러 발생');
        } else {
          final list = bukkungLists.data!;
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 50),
              Column(
                children: List.generate(list.length, (index) {
                  final bukkungList = list[index];
                  return _suggestionListCard(bukkungList, index, false);
                }),
              ),
              SizedBox(height: 20),
            ],
          );
        }
        return Center(child: Text('아직 버꿍리스트가 없습니다'));
      },
    );
  }

  Widget _suggestionListCard(
      BukkungListModel bukkungListModel, int index, bool isDelete) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTap: () {
          final updatedList = controller.selectedList.value.copyWith(
            listId: bukkungListModel.listId,
            title: bukkungListModel.title,
            content: bukkungListModel.content,
            location: bukkungListModel.location,
            category: bukkungListModel.category,
            imgUrl: bukkungListModel.imgUrl,
            imgId: bukkungListModel.imgId,
            madeBy: bukkungListModel.madeBy,
            likedUsers: bukkungListModel.likedUsers,
            likeCount: bukkungListModel.likeCount,
            viewCount: bukkungListModel.viewCount,
          );
          controller.indexSelection(updatedList, index);
          controller.viewCount();
        },
        child: Stack(
          children: [
            Obx(() {
              int? viewCount = bukkungListModel.viewCount;
              NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
              String formattedViewCount = formatter.format(viewCount);
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.only(left: 120, right: 30),
                height: 85,
                decoration: BoxDecoration(
                    color: bukkungListModel.listId ==
                            controller.selectedList.value.listId
                        ? CustomColors.lightPink.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: bukkungListModel.listId ==
                              controller.selectedList.value.listId
                          ? CustomColors.mainPink
                          : Colors.white,
                      width: 2,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarqueeAbleText(
                      text: bukkungListModel.title!,
                      maxLength: 10,
                      style: TextStyle(
                          fontSize: 25, color: CustomColors.blackText),
                    ),
                    SizedBox(height: 20),
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
                            null,
                            '${bukkungListModel.likeCount.toString()}개',
                            false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }),
            Container(
              width: 100,
              height: 100,
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
                  image: NetworkImage(bukkungListModel.imgUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isDelete)
              Positioned(
                right: 0,
                child: CustomIconButton(
                  onTap: () {
                    final updatedList = controller.selectedList.value.copyWith(
                      listId: bukkungListModel.listId,
                      title: bukkungListModel.title,
                      content: bukkungListModel.content,
                      location: bukkungListModel.location,
                      category: bukkungListModel.category,
                      imgUrl: bukkungListModel.imgUrl,
                      imgId: bukkungListModel.imgId,
                      madeBy: bukkungListModel.madeBy,
                      likedUsers: bukkungListModel.likedUsers,
                      likeCount: bukkungListModel.likeCount,
                      viewCount: bukkungListModel.viewCount,
                    );
                    controller.indexSelection(updatedList, index);
                    openAlertDialog(
                      title: '정말로 지우시겠습니다?',
                      secondButtonText: '취소',
                      function: () {
                        controller.listDelete();
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
        image == null
            ? Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.black.withOpacity(0.5),
              )
            : Image.asset(
                'assets/icons/$image',
                width: 25,
                color: CustomColors.grey.withOpacity(0.5),
                colorBlendMode: BlendMode.modulate,
              ),
        marquee
            ? MarqueeAbleText(
                text: text,
                maxLength: 5,
                style: TextStyle(
                  fontSize: 15,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
      ],
    );
  }

  Widget _suggestionMyList() {
    return StreamBuilder(
      stream: controller.getSuggestionMyBukkungList(),
      builder: (BuildContext context,
          AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
        if (!bukkungLists.hasData) {
          return Center(
            child: CircularProgressIndicator(color: CustomColors.mainPink),
          );
        } else if (bukkungLists.hasError) {
          openAlertDialog(title: '에러 발생');
        } else {
          final list = bukkungLists.data!;
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 400),
              Column(
                children: List.generate(list.length, (index) {
                  final bukkungList = list[index];
                  return _suggestionListCard(bukkungList, index, true);
                }),
              ),
              SizedBox(height: 20),
            ],
          );
        }
        return Center(child: Text('아직 버꿍리스트가 없습니다'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ListSuggestionPageController());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.isSearchResult(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CustomColors.mainPink,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          title: Text(
            '추천 리스트',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => UploadBukkungListPage());
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _background(),
                _suggestionListTab(),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 80),
                CategorySelectTabBar(
                  tabController: controller.suggestionListTabController,
                  selectedColor: Colors.black.withOpacity(0.8),
                  unselectedColor: Colors.black.withOpacity(0.5),
                  isMyTab: true,
                ),
                _selectedImage(),
              ],
            ),
            _listPlayButton(),
            _searchBar(),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: _listAddButton(),
      ),
    );
  }
}
