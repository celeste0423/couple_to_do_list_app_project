import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/controller/read_suggestion_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/controller/read_bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/upload_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/upload_diary/pages/upload_diary_page.dart';
import 'package:couple_to_do_list_app/helper/firebase_analytics.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/comment_model.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/category_to_text.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/level_icon.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:couple_to_do_list_app/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReadSuggestionListPage extends GetView<ReadSuggestionListPageController> {
  const ReadSuggestionListPage({
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
      // title: TitleText(
      //   text: '상세보기',
      // ),
      actions: [
        CupertinoButton(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: Text(
            '가져오기',
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.blackText,
            ),
          ),
          onPressed: () {
            Analytics().logEvent('copy_bukkunglist', null);
            controller.setCopyCount();
            Get.off(
              () => UploadBukkungListPage(),
              arguments: [controller.bukkungListModel, true],
            );
          },
        ),
      ],
    );
  }

  Widget _detailContent() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 10),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Text(
                        'by: ${controller.bukkungListModel.madeBy ?? ''}',
                        style: TextStyle(
                          color: CustomColors.greyText,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 5),
                      Obx(() => LevelIcon(level: controller.userLevel.value)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: (Get.width - 60) / 2),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: (Get.width - 80) / 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: BkText(
                                '업로드: ${controller.bukkungListModel.createdAt!.toString().substring(0, 10)}',
                                style: TextStyle(
                                  color: CustomColors.greyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
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
          ],
        ),
        Positioned(
          left: 50,
          top: 120,
          child: Obx(
            () => Container(
              height: Get.width - 100,
              width: Get.width - 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CustomCachedNetworkImage(controller.imgUrl.value),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _commentSection() {
    return Container(
      color: Colors.white,
      child: StreamBuilder<List<CommentModel>>(
          stream: controller.getComments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: CustomColors.mainPink,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('댓글을 불러오는 중 에러가 발생했습니다.'),
              );
            } else {
              List<CommentModel> comments = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      '댓글 ${comments.length}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  customDivider(),
                  _comments(comments),
                  _commentTextField(),
                ],
              );
            }
          }),
    );
  }

  Widget _comments(List<CommentModel> comments) {
    return Column(
      children: List.generate(comments.length, (index) {
        CommentModel commentData = comments[index];
        return _comment(commentData, index);
      }),
    );
  }

  Widget _comment(CommentModel commentData, int index) {
    print('${commentData.uid} ${controller.bukkungListModel.userId}');
    return Container(
      height: 80,
      color: index % 2 == 1 ? CustomColors.backgroundLightGrey : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        'assets/images/high_dpi_background_bukkung.png'), // 이미지 경로에 맞게 수정
                  ),
                ),
              ),
              SizedBox(width: 10),
              commentData.uid == controller.bukkungListModel.userId
                  ? Text(
                      "${commentData.nickname}(작성자)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: CustomColors.mainPink,
                      ),
                    )
                  : Text(
                      commentData.nickname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
              SizedBox(width: 10),
              Text(
                timeago.format(commentData.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors.greyText,
                ),
              ),
              Expanded(child: Container()),
              commentData.uid == AuthController.to.user.value.uid
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.deleteComment(commentData.commentId);
                      },
                      child: Icon(
                        Icons.delete,
                        color: CustomColors.grey,
                        size: 15,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 10),
          Text(
            commentData.comment,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentTextField() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Colors.black.withOpacity(0.2),
            )
          ]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentTextController,
              maxLines: 1,
              maxLength: 30,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              cursorColor: CustomColors.darkGrey,
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: '',
                hintText: '댓글을 입력하세요',
                hintStyle: TextStyle(
                  color: CustomColors.greyText,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Obx(() {
            return controller.isCommentUploading.value
                ? Container(
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                      color: CustomColors.mainPink,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (controller.commentTextController.text
                          .trim()
                          .isEmpty) {
                        openAlertDialog(title: '댓글을 입력하세요');
                      } else {
                        await controller.setComment();
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        color: CustomColors.mainPink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReadSuggestionListPageController());
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _detailContent(),
            SizedBox(height: 10),
            _commentSection(),
          ],
        ),
      ),
    );
  }
}
