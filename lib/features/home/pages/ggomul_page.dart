import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_to_do_list_app/features/home/controller/ggomul_page_controller.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/pages/read_completed_list_page.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/utils/type_to_color.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GgomulPage extends GetView<GgomulPageController> {
  const GgomulPage({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: CustomColors.lightPink,
      title: TitleText(
        text: '진척도',
      ),
    );
  }

  Widget _listCount() {
    return Column(
      children: [
        Obx(
          () => Text(
            '${(controller.completedListCount.value % 8) / 8 * 100}%',
            style: TextStyle(
              fontSize: 15,
              color: CustomColors.blackText,
            ),
          ),
        ),
        Obx(
          () => Text(
            '(${controller.completedListCount.value % 8}/8)',
            style: TextStyle(
              fontSize: 12,
              color: CustomColors.darkGrey,
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              height: 300,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(6, 2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Obx(
                () => AnimatedContainer(
                  height: (controller.completedListCount.value / 8) * 300,
                  width: 25,
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CustomColors.lightPink.withOpacity(0.8),
                        CustomColors.mainPink
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ggomulCard() {
    return Container(
      height: 320,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            spreadRadius: 2,
            blurRadius: 3,
          )
        ],
      ),
      child: Center(
        child: Container(
          height: 290,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: CustomColors.lightPink,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PcText(
                '버꿍이',
                style: TextStyle(fontSize: 35),
              ),
              Obx(
                () => Text(
                  '${((controller.completedListCount.value - (controller.completedListCount.value % 8)) / 8 + 1).toInt()}단계',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/ggomool.png',
                width: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completedList() {
    return Expanded(
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: StreamBuilder(
          stream: controller.getAllCompletedList(),
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
              // print('리스트 출력(buk page)${list.length}');
              if (list.isNotEmpty) {
                return ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 30,
                            color: CustomColors.darkGrey,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '완료한 버킷리스트',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Obx(() => Text(
                                    '${controller.completedListCount.value}개',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: List.generate(list.length, (index) {
                        final bukkungList = list[index];
                        return _completedListCard(bukkungList);
                      }),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(child: Text('완료한 버꿍리스트가 없습니다')),
                );
              }
            }
            return Center(child: Text('완료한 버꿍리스트가 없습니다'));
          },
        ),
      ),
    );
  }

  Widget _completedListCard(BukkungListModel bukkungListModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ReadCompletedListPage(), arguments: bukkungListModel);
        },
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    BoxShadow(
                      offset: Offset(-5, 0),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: '${bukkungListModel.imgUrl}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: CustomColors.blackText,
                                ),
                              ),
                            ),
                          ),
                          // MarqueeAbleText(
                          //   text: bukkungListModel.title!,
                          //   maxLength: 10,
                          //   style: TextStyle(
                          //     fontSize: 25,
                          //     color: CustomColors.blackText,
                          //   ),
                          // ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: BkText(
                              DateFormat('yyyy-MM-dd')
                                  .format(bukkungListModel.date!),
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              PngIcon(
                                iconName: 'location-pin',
                                iconSize: 20,
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
                                        maxLines: 2,
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
                height: 90,
                decoration: BoxDecoration(
                  color: TypeToColor.typeToColor(bukkungListModel.category),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    BoxShadow(
                      offset: Offset(5, 0),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    openAlertDialog(
                      title: '정말로 지우시겠습니까?',
                      content: '지운 내용은 복구할 수 없습니다',
                      secondButtonText: '취소',
                      mainfunction: () {
                        controller.deleteCompletedList(bukkungListModel);
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
    Get.put(GgomulPageController());
    return Scaffold(
      backgroundColor: CustomColors.lightPink,
      appBar: _appBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _listCount(),
                _ggomulCard(),
              ],
            ),
          ),
          SizedBox(height: 30),
          _completedList(),
          SizedBox(height: 110),
        ],
      ),
    );
  }
}
