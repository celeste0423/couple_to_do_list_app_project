import 'package:couple_to_do_list_app/features/home/controller/diary_page_controller.dart';
import 'package:couple_to_do_list_app/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_select_tab_bar.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:couple_to_do_list_app/widgets/short_h_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryPageTest extends GetView<DiaryPageController> {
  const DiaryPageTest({super.key});

  //ToDo: 파이어베이스에서 가져온 정보로 채워 넣을 것

  Widget _diarySliver() {
    const double maxHeaderHeight = 350;
    const double minHeaderHeight = kToolbarHeight + 170;

    return CustomScrollView(
      // controller: controller.sliverScrollController,
      slivers: [
        SliverPersistentHeader(
          delegate: SliverPersistentDelegate(
            controller,
            controller.diaryTabController.index,
            maxHeaderHeight,
            minHeaderHeight,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: Get.height - kToolbarHeight - minHeaderHeight,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                ShortHBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  //Todo: 색상 입력 안해도 되도록 기본값 넣어뒀는데도 오류가 발생하는 이유..?
                  child: CategorySelectTabBar(
                    tabController: controller.diaryTabController,
                    selectedColor: CustomColors.darkGrey,
                    unselectedColor: CustomColors.grey.withOpacity(0.5),
                  ),
                ),
                _diaryListTabView(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _diaryListTabView() {
    return Obx(
      () => Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TabBarView(
              controller: controller.diaryTabController,
              children: [
                _diaryList(0),
                _diaryList(1),
                _diaryList(2),
                _diaryList(3),
                _diaryList(4),
                _diaryList(5),
                _diaryList(6),
              ],
            )),
      ),
    );
  }

  Widget _diaryList(int tabIndex) {
    return controller.diaryList[tabIndex].length == 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 240),
            child: Center(
              child: Text('아직 다이어리가 없습니다'),
            ),
          )
        : ListView.builder(
            itemCount: controller.diaryList.length,
            itemBuilder: (BuildContext context, int index) {
              return myListTile(controller.diaryList[tabIndex][index]);
            },
          );
  }

  Widget myListTile(DiaryModel diaryModel) {
    String dateString = diaryModel.date != null
        ? DateFormat('yyyy-MM-dd').format(diaryModel.date!)
        : '';
    return GestureDetector(
      onTap: () {
        controller.indexSelection(diaryModel);
      },
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            border: Border.all(
              color:
                  diaryModel.diaryId! == controller.selectedDiary.value!.diaryId
                      ? CustomColors.grey.withOpacity(0.4)
                      : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 85,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(diaryModel.imgUrlList![0]),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(5, 5), // Offset(수평, 수직)
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diaryModel.title ?? '',
                    style: TextStyle(fontSize: 25),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        diaryModel.location ?? '',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    dateString,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DiaryPageController());
    return Scaffold(
      backgroundColor: CustomColors.lightPink,
      appBar: AppBar(
        backgroundColor: CustomColors.lightPink,
        title: Text(
          '다이어리',
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                Get.to(() => UploadDiaryPage());
              },
              icon: Image.asset(
                'assets/icons/plus.png',
                color: CustomColors.darkGrey.withOpacity(0.7),
                colorBlendMode: BlendMode.modulate,
                width: 35,
              ),
            ),
          ),
        ],
      ),
      body: _diarySliver(),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  DiaryPageController controller;

  int tabIndex;

  final double maxHeaderHeight;
  final double minHeaderHeight;

  SliverPersistentDelegate(
    this.controller,
    this.tabIndex,
    this.maxHeaderHeight,
    this.minHeaderHeight,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset, // maxextend 범위 내에서 얼마나 늘어났는 지 정도
    bool overlapsContent, //다른 슬리버와 겹치는 지 여부
  ) {
    final percent = 1 - shrinkOffset / (maxHeaderHeight);
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Obx(
            //   () => RotatedBox(
            //     quarterTurns: 135,
            //     child: Text(
            //       //todo: nickname 가져올것
            //       '${controller.maleNickname} 🤍 ${controller.femaleNickname}',
            //       style: TextStyle(
            //           color: Colors.black.withOpacity(0.4), fontSize: 25),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom:
                    percent < 0.8 ? 50 * (percent + 0.2) * (percent + 0.2) : 50,
                right: 20,
              ),
              child: Container(
                width: 230 * percent,
                height: 295 * percent,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset:
                          Offset(15 * percent, 15 * percent), // Offset(수평, 수직)
                    ),
                  ],
                ),
                child: Obx(() {
                  if (controller.diaryList[tabIndex].isEmpty) {
                    return Center(
                      child: Container(
                        width: 150 * percent,
                        height: 170 * percent,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: CustomColors.backgroundLightGrey,
                        ),
                      ),
                    );
                    // //todo: 여기 프로그래스 인디케이터 넣자
                    // return Center(
                    //   child: SizedBox(
                    //     width: 50 * percent,
                    //     height: 50 * percent,
                    //     child: CircularProgressIndicator(
                    //       color: CustomColors.mainPink,
                    //     ),
                    //   ),
                    // );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          controller.selectedDiary.value!.title!,
                          style: TextStyle(fontSize: 35),
                        ),
                        Container(
                          width: 150 * percent,
                          height: 170 * percent,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.selectedDiary.value!.imgUrlList![0],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),

                          //사진이 없을경우 기본 이미지 꼬물이로
                          // child: Image.asset(
                          //   'assets/images/ggomool.png',
                          //   width: 170,
                          //   height: 170,
                          // ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(controller.selectedDiary.value!.date!),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
          ],
        ),
        Positioned(
          top: 140 * percent,
          right: 75 + 105 * (1 - percent),
          child: CustomIconButton(
            onTap: () {
              Get.to(
                () => ReadDiaryPage(),
                arguments: controller.selectedDiary.value,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
