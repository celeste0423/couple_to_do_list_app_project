import 'package:couple_to_do_list_app/features/read_bukkung_list/controller/read_bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/category_to_text.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadBukkungListPage extends GetView<ReadBukkungListPageController> {
  const ReadBukkungListPage({
    Key? key,
  }) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
      ),
      title: TitleText(
        text: '상세보기',
      ),
      actions: [
        PopupMenuButton(
          offset: Offset(0, 50),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Get.to(
                    () => UploadBukkungListPage(),
                    arguments: [controller.bukkungListModel, false],
                  );
                },
                child: Text(
                  "수정하기",
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
          child: Icon(
            Icons.more_vert,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _detailContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  CategoryIcon(
                    category: controller.bukkungListModel.category!,
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Text(
                    CategoryToText(controller.bukkungListModel.category!),
                    style: TextStyle(
                      color: CustomColors.greyText,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: PcText(
                        controller.bukkungListModel.title!,
                        style: TextStyle(
                          color: CustomColors.blackText,
                          fontSize: 30,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Expanded(
                //   flex: 1,
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.only(left: 10, right: 10, top: 10),
                //     child: FittedBox(
                //       fit: BoxFit.scaleDown,
                //       child: Text(
                //         controller.bukkungListModel.date!
                //             .toString()
                //             .substring(0, 10),
                //         style: TextStyle(
                //           color: CustomColors.greyText,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
              child: Obx(
                () => Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    image: CustomCachedNetworkImage(
                        controller.imgUrl.value,BoxFit.cover
                      ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      PngIcon(
                        iconName: 'location-pin',
                        iconSize: 30,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: BkText(
                          controller.bukkungListModel.location!,
                          style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.blackText,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: BkText(
                        controller.bukkungListModel.date == null
                            ? '미정'
                            : controller.bukkungListModel.date!
                                .toString()
                                .substring(0, 10),
                        style: TextStyle(
                          color: CustomColors.greyText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topLeft,
                child: BkText(
                  controller.bukkungListModel.content!,
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.blackText,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: GestureDetector(
        onTap: () {
          openAlertDialog(
            title: '버꿍리스트를 완료하셨나요?',
            btnText: '네',
            secondButtonText: '아니요',
            secondfunction: () {
              Get.back(); //dialog back
            },
            mainfunction: () async {
              Get.back(); //다이알로드 꺼지고,
              DiaryModel updatedDiaryModel =
                  await controller.listCompleted(); //완료리스트 올라가고
              bool ismainButtonClicked = await openBoolAlertDialog(
                title: '다이어리를 작성하시겠어요?',
                btnText: '네',
                content: '버꿍이 진척도가 올라갔어요!',
                secondButtonText: '아니요',
              );
              if (ismainButtonClicked) {
                // Main button was clicked
                Get.off(() => UploadDiaryPage(), arguments: updatedDiaryModel);
              } else {
                Get.back();
              }
            },
          );
        },
        child: Container(
          width: 140,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: CustomColors.mainPink,
          ),
          child: Center(
            child: Text(
              '리스트 완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReadBukkungListPageController());
    return Scaffold(
      appBar: _appBar(),
      body: _detailContent(),
      bottomNavigationBar: _bottomBar(),
    );
  }
}
