import 'package:couple_to_do_list_app/src/features/read_bukkung_list/controller/read_bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/src/utils/category_to_text.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/src/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/src/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/src/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/src/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
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
        child: CupertinoButton(
          onPressed: () {
            Get.back();
          },
          padding: const EdgeInsets.all(0),
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: CustomColors.grey,
          ),
        ),
      ),
      title: TitleText(
        text: '상세보기',
      ),
      actions: [
        PopupMenuButton(
          onSelected: (result) {
            if (result == 0) {
              Get.to(
                () => UploadBukkungListPage(),
                arguments: [controller.bukkungListModel, false],
              );
            }
          },
          offset: Offset(0, 50),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "수정하기",
                  style: TextStyle(
                    fontSize: 14,
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
                    image: DecorationImage(
                        image:
                            CustomCachedNetworkImage(controller.imgUrl.value),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
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
                            ? '날짜 미정'
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
          controller.listCompletedButton();
        },
        child: Container(
          width: 140,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.bukkungListModel.isCompleted == null
                ? CustomColors.mainPink
                : controller.bukkungListModel.isCompleted!
                    ? CustomColors.grey
                    : CustomColors.mainPink,
          ),
          child: Center(
            child: Text(
              controller.bukkungListModel.isCompleted == null
                  ? '리스트 완료'
                  : controller.bukkungListModel.isCompleted!
                      ? '리스트 완료 취소'
                      : '리스트 완료',
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
