import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/pages/list_suggestion_page.dart';
import 'package:couple_to_do_list_app/features/setting/pages/setting_page.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/utils/type_to_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/marquee_able_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BukkungListPage extends GetView<BukkungListPageController> {
  const BukkungListPage({Key? key}) : super(key: key);

  Widget _listAddButton() {
    return GestureDetector(
      onTap: () {
        //Todo: route로 파일 뽑아낼 것
        Get.to(() => ListSuggestionPage());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/plus.png',
              width: 30,
              color: Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
            SizedBox(width: 20),
            Material(
              type: MaterialType.transparency,
              child: Text(
                '여기를 눌러 버꿍리스트를 추가하세요',
                style: TextStyle(
                  color: CustomColors.grey.withOpacity(0.5),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "category",
                child: Text(
                  "카테고리 별",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Yoonwoo',
                    letterSpacing: 1.5,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "date",
                child: Text(
                  "최신 순",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Yoonwoo',
                    letterSpacing: 1.5,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: "redate",
                child: Text(
                  "이전 순",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Yoonwoo',
                    letterSpacing: 1.5,
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
                Hero(
                  tag: 'background',
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: CustomColors.mainPink,
                  ),
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
          child: StreamBuilder(
            stream: BukkungListPageController.to.getAllBukkungListByCategory(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child:
                      CircularProgressIndicator(color: CustomColors.mainPink),
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
                  return Center(child: Text('아직 버꿍리스트가 없습니다'));
                }
              }
              return Center(child: Text('아직 버꿍리스트가 없습니다'));
            },
          ),
        );
      } else {
        return Expanded(
          child: StreamBuilder(
            stream: BukkungListPageController.to.getAllBukkungList(
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
                  return Center(child: Text('아직 버꿍리스트가 없습니다'));
                }
              }
              return Center(child: Text('아직 버꿍리스트가 없습니다'));
            },
          ),
        );
      }
    });
  }

  Widget _categoryDivider(int categoryNumber) {
    switch (categoryNumber) {
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '1travel'),
              SizedBox(width: 10),
              Text('여행', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '2meal'),
              SizedBox(width: 10),
              Text('식사', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '3activity'),
              SizedBox(width: 10),
              Text('액티비티', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '4culture'),
              SizedBox(width: 10),
              Text('문화 활동', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case 5:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '5study'),
              SizedBox(width: 10),
              Text('자기 계발', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case 6:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              CategoryIcon(category: '6etc'),
              SizedBox(width: 10),
              Text('기타', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _bukkungListCard(BukkungListModel bukkungListModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                      child: Image.network(
                        '${bukkungListModel.imgUrl}',
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MarqueeAbleText(
                          text: bukkungListModel.title!,
                          maxLength: 10,
                          style: TextStyle(
                            fontSize: 25,
                            color: CustomColors.blackText,
                          ),
                        ),
                        Text(DateFormat('yyyy-MM-dd')
                            .format(bukkungListModel.date!)),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/location-pin.png',
                              color: CustomColors.grey.withOpacity(0.5),
                              colorBlendMode: BlendMode.modulate,
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            MarqueeAbleText(
                              text: bukkungListModel.location!,
                              maxLength: 20,
                              style: TextStyle(
                                fontSize: 15,
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
              height: 120,
              decoration: BoxDecoration(
                color: TypeToColor.typeToColor(bukkungListModel.category),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              width: 30,
              child: GestureDetector(
                onTap: () {
                  openAlertDialog(
                      title: '정말로 지우시겠습니다?',
                      secondButtonText: '취소',
                      function: () {
                        controller.deleteBukkungList(bukkungListModel);
                        Get.back();
                      });
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Get.put(BukkungListPageController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundLightGrey,
        title: Text('버꿍리스트'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SettingsPage());
            },
            icon: Image.asset(
              'assets/icons/setting.png',
              color: Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Hero(tag: 'addButton', child: _listAddButton()),
          _listTypeSelector(),
          Hero(
            tag: 'search_bar',
            child: customDivider(),
          ),
          _bukkungListView(),
        ],
      ),
    );
  }
}
