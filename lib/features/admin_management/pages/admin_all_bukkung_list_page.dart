import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/pages/read_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/utils/type_to_color.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/admin_bukkung_list_page_controller.dart';

class AdminBukkungListPage extends GetView<AdminBukkungListPageController> {
  const AdminBukkungListPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.backgroundLightGrey,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image(image: AssetImage('assets/images/title_horizontal.png')),
      ),
      leadingWidth: 190,
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

  Widget _bukkungListView() {
    return Expanded(
      child: StreamBuilder(
        stream: controller.listByDateStreamController.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<BukkungListModel>> bukkungLists,
        ) {
          if (!bukkungLists.hasData) {
            return Center(
              child: CircularProgressIndicator(color: CustomColors.mainPink),
            );
          } else if (bukkungLists.hasError) {
            openAlertDialog(title: '에러 발생');
          } else {
            final list = bukkungLists.data!;
            // print('리스트 출력(buk page)${list.length}');
            if (list.isNotEmpty) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller.listByDateScrollController,
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

  Widget _bukkungListCard(BukkungListModel bukkungListModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ReadBukkungListPage(), arguments: bukkungListModel);
        },
        child: Row(
          children: [
            Expanded(
              flex: 12,
              child: Container(
                height: 100,
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
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CustomCachedNetworkImage(
                                  bukkungListModel.imgUrl!),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(25),
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
                          Row(
                            children: [
                              PngIcon(
                                iconName: 'location-pin',
                                iconSize: 25,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: BkText(
                                        bukkungListModel.location!,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          bukkungListModel.imgUrl == Constants.baseImageUrl
                              ? CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await controller
                                        .updateAutoImage(bukkungListModel);
                                  },
                                  child: Text(
                                    '사진 자동 추가',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Container(),
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
                height: 100,
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
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AdminBukkungListPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // _listTypeSelector(),
          // CustomDivider(),
          _bukkungListView(),
        ],
      ),
    );
  }
}
