import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/controller/read_bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/list_completed_repository.dart';
import 'package:couple_to_do_list_app/utils/category_to_text.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
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
                  CategoryIcon(category: controller.bukkungListModel.category!),
                  SizedBox(width: 10),
                  Text(
                    CategoryToText(controller.bukkungListModel.category!),
                    style: TextStyle(
                      color: CustomColors.blackText,
                      fontSize: 25,
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      controller.bukkungListModel.title!,
                      style: TextStyle(
                        color: CustomColors.blackText,
                        fontSize: 35,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        controller.bukkungListModel.date!
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
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
              child: Obx(
                () => Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        controller.imgUrl.value!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    PngIcon(iconName: 'location-pin'),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          controller.bukkungListModel.location!,
                          style: TextStyle(
                            color: CustomColors.blackText,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  controller.bukkungListModel.content!,
                  style: TextStyle(
                    color: CustomColors.blackText,
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
          ListCompletedRepository.setCompletedBukkungList(
              controller.bukkungListModel);
          BukkungListPageController.to
              .deleteBukkungList(controller.bukkungListModel);

          DiaryModel diaryModel = DiaryModel.init(AuthController.to.user.value);
          DiaryModel updatedDiaryModel = diaryModel.copyWith(
            title: controller.bukkungListModel.title,
            category: controller.bukkungListModel.category,
            location: controller.bukkungListModel.category,
            date: controller.bukkungListModel.date,
            updatedAt: DateTime.now(),
          );
          Get.off(() => UploadDiaryPage(), arguments: updatedDiaryModel);
        },
        child: Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: CustomColors.mainPink,
          ),
          child: Center(
            child: Text(
              '리스트 완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
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
