import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/notification/pages/notification_page.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/pages/read_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/store/pages/store.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/helper/firebase_analytics.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/utils/type_to_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BukkungListPage extends GetView<BukkungListPageController> {
  const BukkungListPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image(image: AssetImage('assets/images/title_horizontal.png')),
      ),
      leadingWidth: 190,
      //알림 페이지 버튼
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => StorePage());
            },
            icon: Icon(Icons.shopping_bag_outlined, size: 30, weight: 4,)
        ),
        Stack(
          children: [
            CupertinoButton(
              onPressed: () {
                Get.to(NotificationPage());
              },
              padding: const EdgeInsets.only(top: 10, right: 10),
              // child: Gif(
              //   image: AssetImage('assets/gifs/notification_bell.gif'),
              //   autostart: Autostart.loop,
              // ),
              child: Image(
                image: AssetImage('assets/gifs/notification_bell_short.gif'),
                width: 55,
                height: 55,
                color: CustomColors.grey.withOpacity(0.5),
                colorBlendMode: BlendMode.modulate,
              ),
              // child: Icon(
              //   Icons.notifications,
              //   color: CustomColors.lightGrey,
              //   size: 28,
              // ),
            ),
            Obx(
              () {
                return controller.isNotification.value
                    ? Positioned(
                        top: controller.isAnimated.value ? 17 : 18,
                        right: controller.isAnimated.value ? 24 : 25,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 50),
                          width: controller.isAnimated.value ? 9 : 7,
                          height: controller.isAnimated.value ? 9 : 7,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ],
        )
      ],
    );
  }

  // Widget _listAddButton() {
  //   return GestureDetector(onTap: () {
  //     Get.to(() => ListSuggestionPage());
  //   }, child: Obx(() {
  //     return AnimatedContainer(
  //       key: controller.listSuggestionKey,
  //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //       padding: EdgeInsets.symmetric(
  //           horizontal: controller.isAnimated.value ? 8 : 10),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(25),
  //         border: Border.all(
  //           width: controller.isAnimated.value ? 2 : 0,
  //           color: controller.isAnimated.value
  //               ? CustomColors.lightPink
  //               : Colors.transparent,
  //         ),
  //         color: CustomColors.mainPink,
  //       ),
  //       height: 50,
  //       duration: Duration(milliseconds: 1000),
  //       curve: Curves.easeOut,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           // PngIcon(
  //           //   iconName: 'plus',
  //           //   iconColor: Colors.white.withOpacity(0.7),
  //           //   iconSize: 30,
  //           // ),
  //           Icon(
  //             Icons.add,
  //             color: Colors.white,
  //             size: 35,
  //           ),
  //           SizedBox(width: 10),
  //           Material(
  //             type: MaterialType.transparency,
  //             child: Text(
  //               '여기를 눌러 버꿍리스트를 추가하세요',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }));
  // }

  Widget _listTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 150,
        child: PopupMenuButton<String>(
          offset: Offset(0, 40),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          onSelected: (String listType) {
            controller.currentType.value = listType;
            controller.saveSelectedListType(listType);
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "category",
                child: Text(
                  "카테고리 별",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nanum',
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "created_at",
                child: Text(
                  "리스트 추가순",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nanum',
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "date",
                child: Text(
                  "최신 날짜순",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nanum',
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "redate",
                child: Text(
                  "이전 날짜순",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nanum',
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
            ];
          },
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(controller.typetoString[controller.currentType.value] ??
                    ""),
                Icon(
                  Icons.arrow_drop_down,
                  color: CustomColors.mainPink,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _bukkungListView() {
    return Obx(() {
      if (controller.currentType.value == 'category') {
        return Expanded(
          // key: controller.bukkungListKey,
          child: StreamBuilder(
            stream: BukkungListPageController.to.getAllBukkungListByCategory(),
            builder: (
              BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: CustomColors.mainPink,
                  ),
                );
              } else if (snapshot.hasError) {
                openAlertDialog(title: '에러 발생');
              } else if (snapshot.hasData) {
                final list =
                    snapshot.data!['bukkungLists'] as List<BukkungListModel>;
                final categoryCount =
                    snapshot.data!['categoryCount'] as List<int>;
                // print('리스트 출력(buk page)${list.length}');

                if (list.isNotEmpty) {
                  return ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      // _characterBox(),
                      Column(
                        children: List.generate(list.length, (index) {
                          final bukkungList = list[index];

                          if (categoryCount[0] != 0 && index == 0) {
                            return Column(
                              children: [
                                _categoryDivider(1),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          } else if (categoryCount[1] != 0 &&
                              index == categoryCount[0]) {
                            return Column(
                              children: [
                                _categoryDivider(2),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          } else if (categoryCount[2] != 0 &&
                              index == categoryCount[0] + categoryCount[1]) {
                            return Column(
                              children: [
                                _categoryDivider(3),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          } else if (categoryCount[3] != 0 &&
                              index ==
                                  categoryCount[0] +
                                      categoryCount[1] +
                                      categoryCount[2]) {
                            return Column(
                              children: [
                                _categoryDivider(4),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          } else if (categoryCount[4] != 0 &&
                              index ==
                                  categoryCount[0] +
                                      categoryCount[1] +
                                      categoryCount[2] +
                                      categoryCount[3]) {
                            return Column(
                              children: [
                                _categoryDivider(5),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          } else if (categoryCount[5] != 0 &&
                              index ==
                                  categoryCount[0] +
                                      categoryCount[1] +
                                      categoryCount[2] +
                                      categoryCount[3] +
                                      categoryCount[4]) {
                            return Column(
                              children: [
                                _categoryDivider(6),
                                _bukkungListCard(bukkungList),
                              ],
                            );
                          }
                          return _bukkungListCard(bukkungList);
                        }),
                      ),
                      SizedBox(height: 100),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Center(child: Text('아직 버꿍리스트가 없습니다')),
                  );
                }
              }
              return Center(child: Text('아직 버꿍리스트가 없습니다'));
            },
          ),
        );
      } else {
        return Expanded(
          child: StreamBuilder(
            stream: controller.getAllBukkungList(
              controller.currentType.value!,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<BukkungListModel>> bukkungLists) {
              if (!bukkungLists.hasData) {
                return Center(
                  child:
                      CircularProgressIndicator(color: CustomColors.mainPink),
                );
              } else if (bukkungLists.hasError) {
                openAlertDialog(title: '에러 발생');
              } else {
                final list = bukkungLists.data!;
                // print('리스트 출력(buk page)${list.length}');
                if (list.isNotEmpty) {
                  return ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      // _characterBox(),
                      Column(
                        children: List.generate(list.length, (index) {
                          final bukkungList = list[index];
                          return _bukkungListCard(bukkungList);
                        }),
                      ),
                      SizedBox(height: 100),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Center(child: Text('아직 버꿍리스트가 없습니다')),
                  );
                }
              }
              return Center(child: Text('아직 버꿍리스트가 없습니다'));
            },
          ),
        );
      }
    });
  }

  // Widget _characterBox() {
  //   return Container(
  //     width: 300,
  //     height: 300,
  //     margin: EdgeInsets.symmetric(horizontal: 30),
  //     decoration: BoxDecoration(
  //       // color: CustomColors.lightGrey,
  //       borderRadius: BorderRadius.circular(150),
  //     ),
  //     child: CupertinoButton(
  //       padding: EdgeInsets.zero,
  //       onPressed: () {},
  //       child: RiveAnimation.asset(
  //         'assets/rivs/bukkung.riv',
  //         stateMachines: ["bukkung"],
  //         // onInit: controller.onRiveInit,
  //       ),
  //     ),
  //   );
  // }

  Widget _categoryDivider(int categoryNumber) {
    switch (categoryNumber) {
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '1travel'),
              SizedBox(width: 10),
              Text('여행', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '2meal'),
              SizedBox(width: 10),
              Text('식사', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '3activity'),
              SizedBox(width: 10),
              Text('액티비티', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '4culture'),
              SizedBox(width: 10),
              Text('문화 활동', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case 5:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '5study'),
              SizedBox(width: 10),
              Text('자기 계발', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case 6:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: const [
              CategoryIcon(category: '6etc'),
              SizedBox(width: 10),
              Text('기타', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _bukkungListCard(BukkungListModel bukkungListModel) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onPressed: () {
        Analytics().logEvent('group_bukkunglist_read', null);
        Get.to(() => ReadBukkungListPage(), arguments: bukkungListModel);
      },
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CustomCachedNetworkImage(
                                bukkungListModel.imgUrl!),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: PcText(
                              bukkungListModel.title!,
                              style: TextStyle(
                                fontSize: 20,
                                color: CustomColors.blackText,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  PngIcon(
                                    iconName: 'location-pin',
                                    iconSize: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: BkText(
                                            bukkungListModel.location!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: CustomColors.greyText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            bukkungListModel.date == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: BkText(
                                      DateFormat('yyyy-MM-dd')
                                          .format(bukkungListModel.date!),
                                      style: TextStyle(
                                          color: CustomColors.greyText,
                                          fontSize: 12),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: TypeToColor.typeToColor(bukkungListModel.category),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              width: 20,
              child: GestureDetector(
                onTap: () {
                  openAlertDialog(
                    title: '정말로 지우시겠습니까?',
                    secondButtonText: '취소',
                    mainfunction: () {
                      controller.deleteBukkungList(bukkungListModel, true);
                      Get.back();
                    },
                  );
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listAddButton() {
    return FloatingActionButton(
      key: controller.listAddKey,
      onPressed: () {
        // Analytics().logEvent('list_suggestion_page_open', null);
        // Get.to(
        //   () => ListSuggestionPage(),
        //   transition: Transition.fadeIn,
        //   duration: Duration(milliseconds: 500),
        // );
        Analytics().logEvent('made_new_bukkunglist', null);
        Get.to(() => UploadBukkungListPage(), arguments: [null, true]);
      },
      backgroundColor: CustomColors.mainPink,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BukkungListPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _listTypeSelector(),
          CustomDivider(
            key: controller.bukkungListKey,
          ),
          _bukkungListView(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90, right: 10),
        child: _listAddButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
