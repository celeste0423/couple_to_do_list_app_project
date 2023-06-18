import 'package:couple_to_do_list_app/features/home/controller/diary_page_controller.dart';
import 'package:couple_to_do_list_app/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_select_tab_bar.dart';
import 'package:couple_to_do_list_app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryPage extends GetView<DiaryPageController> {
  const DiaryPage({super.key});
  //ToDo: 파이어베이스에서 가져온 정보로 채워 넣을 것
  Widget _diary() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 50),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => RotatedBox(
                  quarterTurns: 135,
                  child: Text(
                    //todo: nickname 가져올것
                    '${controller.maleNickname}🤍${controller.femaleNickname}',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4), fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  width: 230,
                  height: 295,
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
                        offset: Offset(15, 15), // Offset(수평, 수직)
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.diarylist.isEmpty) {
                      //todo: 여기 프로그래스 인디케이터 넣자
                      return Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: CustomColors.mainPink,
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            controller.selectedDiary.value!.title ??
                                controller.diarylist[0].title!,
                            style: TextStyle(fontSize: 35),
                          ),
                          Container(
                            width: 150,
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: NetworkImage(
                                  //todo:이미지 나오게
                                  'https://post-phinf.pstatic.net/MjAxNzEwMjBfNjYg/MDAxNTA4NDY0NzkxMDc3.BXMDJ0jGbaunHr6TRI6N4NOBiGOXAlXbzlmgaZYHMkQg.P6Rbnq9YTv9CCqH5Vgu6JCSEGZC_wOZ25onOnoT4AAAg.PNG/11.png?type=w1200',
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
                            controller.selectedDiary.value!.date != null
                                ? DateFormat('yyyy-MM-dd').format(
                                    controller.selectedDiary.value!.date!)
                                : DateFormat('yyyy-MM-dd')
                                    .format(controller.diarylist[0].date!),
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
              top: 130,
              right: 60,
              child: CustomIconButton(
                onTap: () {
                  Get.to(() => ReadDiaryPage(),
                      arguments: controller.selectedDiary.value);
                },
              )),
        ],
      ),
    );
  }

  Widget _diaryList() {
    Widget myListTile(
        String? title, String? location, DateTime? date, String url) {
      String dateString =
          date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
      return Container(
        height: 90,
        child: Row(
          children: [
            Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(url)))),
            SizedBox(
              width: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
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
                      location ?? '',
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
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.backgroundLightGrey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //Todo: 색상 입력 안해도 되도록 기본값 넣어뒀는데도 오류가 발생하는 이유..?
              child: CategorySelectTabBar(
                tabController: controller.tabDiaryController,
                selectedColor: CustomColors.darkGrey,
                unselectedColor: CustomColors.grey.withOpacity(0.5),
              ),
            ),
            Obx(() => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        itemCount: controller.diarylist.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          return GestureDetector(
                            onTap: () {
                              controller.selectedDiary(controller.diarylist[i]);
                            },
                            child: myListTile(
                              controller.diarylist[i].title,
                              controller.diarylist[i].location,
                              controller.diarylist[i].date,
                              controller.diarylist[i].imgUrlList![0],
                            ),
                          );
                        }),
                  ),
                ))
          ],
        ),
      ),
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
      body: Column(
        children: [
          _diary(),
          _diaryList(),
        ],
      ),
    );
  }
}
