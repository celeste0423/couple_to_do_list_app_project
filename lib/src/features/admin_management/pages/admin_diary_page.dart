import 'package:couple_to_do_list_app/src/constants/constants.dart';
import 'package:couple_to_do_list_app/src/features/admin_management/controller/admin_diary_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/src/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/src/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:couple_to_do_list_app/src/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/src/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/src/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/src/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminDiaryPage extends GetView<AdminDiaryPageController> {
  const AdminDiaryPage({super.key});

  Widget _diaryList() {
    return StreamBuilder(
      stream: controller.listByDateStreamController.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DiaryModel>> bukkungLists,
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
                    return diaryTile(bukkungList);
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
    );
  }

  Widget diaryTile(DiaryModel diaryModel) {
    String createdString =
        DateFormat('yyyy-MM-dd').format(diaryModel.createdAt!);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => ReadDiaryPage(),
              arguments: diaryModel,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 130,
            width: Get.width - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 4, top: 1),
                      height: 85,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          //todo: 이건 뭐지
                          image: CustomCachedNetworkImage(
                              diaryModel.imgUrlList!.isEmpty
                                  ? Constants.baseImageUrl
                                  : diaryModel.imgUrlList![0]),
                          //   image: CachedNetworkImageProvider(
                          //       diaryModel.imgUrlList!.isEmpty ? Constants.baseImageUrl:diaryModel.imgUrlList![0]),
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
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: PcText(
                            diaryModel.title ?? '',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: CustomColors.grey,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: BkText(
                              diaryModel.location ?? '',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      // BkText(
                      //   dateString,
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      BkText(
                        '만든날짜 : $createdString',
                        style: TextStyle(fontSize: 13),
                      ),
                      BkText(
                        diaryModel.creatorUserID!,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AdminDiaryPageController());
    return Scaffold(
      backgroundColor: CustomColors.lightPink,
      appBar: AppBar(
        backgroundColor: CustomColors.lightPink,
        title: TitleText(
          text: '다이어리',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                Get.to(() => UploadDiaryPage(), arguments: null);
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
      body: _diaryList(),
    );
  }
}
