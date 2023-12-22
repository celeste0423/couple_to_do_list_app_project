import 'package:auto_size_text/auto_size_text.dart';
import 'package:couple_to_do_list_app/constants/enum.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:couple_to_do_list_app/widgets/category_icon.dart';
import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
import 'package:couple_to_do_list_app/widgets/custom_divider.dart';
import 'package:couple_to_do_list_app/widgets/marquee_able_text.dart';
import 'package:couple_to_do_list_app/widgets/png_icons.dart';
import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UploadBukkungListPage extends StatefulWidget {
  const UploadBukkungListPage({Key? key}) : super(key: key);

  @override
  State<UploadBukkungListPage> createState() => _UploadBukkungListPageState();
}

class _UploadBukkungListPageState extends State<UploadBukkungListPage> {
  // Create an instance of your controller
  final UploadBukkungListController controller =
      Get.put(UploadBukkungListController());

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: TextButton(
        onPressed: () async {
          Get.back();
        },
        child: Text(
          '취소',
          style: TextStyle(color: CustomColors.greyText),
        ),
      ),
      // actions: [
      //   Obx(() {
      //     return TextButton(
      //       onPressed: controller.isCompleted.value == true
      //           ? () async {
      //               print('업로드 시작(upl page)');
      //               controller.isUploading.value = true;
      //               await controller.uploadBukkungList();
      //               Get.back();
      //               Get.back();
      //             }
      //           : () {
      //               if (controller.titleController.text == '') {
      //                 openAlertDialog(title: '제목을 입력해 주세요');
      //               } else if (controller.listCategory.value == '') {
      //                 openAlertDialog(title: '카테고리를 선택해주세요');
      //               } else if (controller.locationController.text == '') {
      //                 openAlertDialog(title: '위치를 작성해주세요');
      //               }
      //               // else if (controller.listDateTime.value == null) {
      //               //   openAlertDialog(title: '날짜를 선택해주세요');
      //               // }
      //               else if (controller.contentController == '') {
      //                 openAlertDialog(title: '세부 계획을 작성해주세요');
      //               }
      //             },
      //       child: controller.selectedBukkungListModel == null
      //           ? controller.isCompleted.value == true
      //               ? Text('저장', style: TextStyle(color: CustomColors.mainPink))
      //               : Text(
      //                   '저장',
      //                   style: TextStyle(color: CustomColors.greyText),
      //                 )
      //           : controller.isSuggestion == true
      //               ? controller.isCompleted.value == true
      //                   ? Text('내 버꿍에 추가',
      //                       style: TextStyle(color: CustomColors.mainPink))
      //                   : Text(
      //                       '내 버꿍에 추가',
      //                       style: TextStyle(color: CustomColors.greyText),
      //                     )
      //               : controller.isCompleted.value == true
      //                   ? Text('수정 완료',
      //                       style: TextStyle(color: CustomColors.mainPink))
      //                   : Text(
      //                       '수정 완료',
      //                       style: TextStyle(color: CustomColors.greyText),
      //                     ),
      //     );
      //   }),
      // ],
    );
  }

  Widget _titleTextField() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller.titleController,
        focusNode: controller.titleFocusNode,
        maxLines: 2,
        maxLength: 20,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 28,
          fontFamily: "Pyeongchang",
        ),
        cursorColor: CustomColors.mainPink,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15),
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget _searchResult() {
    return GetBuilder<UploadBukkungListController>(
        id: 'uploadPageSearchResult',
        builder: (controller) {
          double height = 0;
          if (controller.searchBukkungLists != null) {
            height = controller.searchBukkungLists!.length * 95;
          }
          return Stack(
            children: [
              Positioned(
                bottom:
                    Get.height - MediaQuery.of(context).viewInsets.bottom - 167,
                left: 20,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    border: Border(
                      bottom:
                          BorderSide(width: 2, color: CustomColors.mainPink),
                      // left: BorderSide(width: 2, color: CustomColors.mainPink),
                      // right: BorderSide(width: 2, color: CustomColors.mainPink),
                      // top: BorderSide(width: 2, color: CustomColors.mainPink),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.isTitleFocused &&
                                !controller.isTitleTextEmpty
                            ? controller.searchBukkungLists != null
                                ? height == 0
                                    ? Colors.transparent
                                    : Colors.black.withOpacity(0.1)
                                : Colors.transparent
                            : Colors.transparent,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 5), // Offset(수평, 수직)
                      ),
                    ],
                  ),
                  width: Get.width - 40,
                  height:
                      controller.isTitleFocused && !controller.isTitleTextEmpty
                          ? controller.searchBukkungLists != null
                              ? height == 0
                                  ? 0
                                  : 75
                              : 0
                          : 0,
                ),
              ),
              Positioned(
                top: 79,
                left: 20,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: Get.width - 40,
                  height:
                      controller.isTitleFocused && !controller.isTitleTextEmpty
                          ? controller.searchBukkungLists != null
                              ? height == 0
                                  ? 0
                                  : height < 85
                                      ? 85
                                      : height > 260
                                          ? 260
                                          : height
                              : 0
                          : 0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    // border: Border(
                    //   left: BorderSide(width: 2, color: CustomColors.mainPink),
                    //   right: BorderSide(width: 2, color: CustomColors.mainPink),
                    //   bottom:
                    //       BorderSide(width: 2, color: CustomColors.mainPink),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.isTitleFocused &&
                                !controller.isTitleTextEmpty
                            ? controller.searchBukkungLists != null
                                ? height == 0
                                    ? Colors.transparent
                                    : Colors.black.withOpacity(0.1)
                                : Colors.transparent
                            : Colors.transparent,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 5), // Offset(수평, 수직)
                      ),
                    ],
                  ),
                  child: Obx(() {
                    return controller.isSearchResultLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : controller.searchBukkungLists == null
                            ? Container()
                            : controller.searchBukkungLists!.isEmpty
                                ? Container()
                                : ListView(
                                    padding: EdgeInsets.only(top: 5),
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: List.generate(
                                            controller.searchBukkungLists!
                                                .length, (index) {
                                          final bukkungList = controller
                                              .searchBukkungLists![index];
                                          return _searchListCard(
                                            bukkungList,
                                            index,
                                            context,
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                  }),
                ),
              ),
            ],
          );
        });
  }

  Widget _searchListCard(
    BukkungListModel bukkungListModel,
    int index,
    BuildContext context,
  ) {
    int? viewCount = bukkungListModel.viewCount;
    NumberFormat formatter = NumberFormat.compact(locale: "ko_KR");
    String formattedViewCount = formatter.format(viewCount);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: CupertinoButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            color: CustomColors.backgroundLightGrey,
            borderRadius: BorderRadius.circular(25),
            // border: Border.all(color: CustomColors.lightGrey, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CustomCachedNetworkImage(bukkungListModel.imgUrl!),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(5, 5), // Offset(수평, 수직)
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: PcText(
                        bukkungListModel.title!,
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.blackText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconText(
                            'location-pin.png',
                            bukkungListModel.location ?? '',
                            true,
                          ),
                          _iconText(
                            'preview.png',
                            '$formattedViewCount회',
                            false,
                          ),
                          // _iconText(
                          //   'likeCount',
                          //   '${bukkungListModel.likeCount.toString()}개',
                          //   false,
                          // ),
                          _iconText(
                            'copyCount',
                            '${bukkungListModel.copyCount.toString()}회',
                            false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconText(String? image, String text, bool marquee) {
    return Row(
      children: [
        image == 'likeCount'
            ? Icon(
                Icons.favorite_border,
                size: 16,
                color: Colors.black.withOpacity(0.5),
              )
            : image == 'copyCount'
                ? Icon(
                    Icons.document_scanner_outlined,
                    size: 16,
                    color: Colors.black.withOpacity(0.5),
                  )
                : Image.asset(
                    'assets/icons/$image',
                    width: 18,
                    color: CustomColors.grey.withOpacity(0.5),
                    colorBlendMode: BlendMode.modulate,
                  ),
        marquee
            ? MarqueeAbleText(
                text: text,
                maxLength: 5,
                style: TextStyle(
                  fontFamily: 'Bookk_mj',
                  fontSize: 11,
                  color: CustomColors.greyText,
                ),
              )
            : BkText(
                text,
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors.greyText,
                ),
              ),
      ],
    );
  }

  Widget _categorySelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Row(
        children: [
          PngIcon(
            iconName: 'category',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.dialog(_categoryDialog());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Obx(() {
                    return Row(
                      children: [
                        CategoryIcon(
                          category: controller.listCategory.value ?? '',
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.categoryToString[
                                  controller.listCategory.value] ??
                              '카테고리',
                          style: TextStyle(
                            color: controller.categoryToString[
                                        controller.listCategory.value] ==
                                    null
                                ? CustomColors.greyText
                                : CustomColors.blackText,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Get.width < 350 || Get.height < 550
          ? SizedBox(
              width: Get.width - 40,
              height: 500,
              //화면이 너무 작을 때만 작동하는 예외처리 UI
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 2.0,
                  shrinkWrap: true,
                  children: [
                    _categoryCard(
                        'airplane', '여행', CustomColors.travel, '1travel'),
                    _categoryCard(
                        'running', '액티비티', CustomColors.activity, '3activity'),
                    _categoryCard(
                        'study', '자기계발', CustomColors.study, '5study'),
                    _categoryCard('food', '식사', CustomColors.meal, '2meal'),
                    _categoryCard(
                        'singer', '문화활동', CustomColors.culture, '4culture'),
                    _categoryCard(
                        'filter-file', '기타', CustomColors.etc, '6etc'),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 550,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '카테고리',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 450,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _categoryCard('airplane', '여행',
                                    CustomColors.travel, '1travel'),
                                _categoryCard('running', '액티비티',
                                    CustomColors.activity, '3activity'),
                                _categoryCard('study', '자기계발',
                                    CustomColors.study, '5study'),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            height: 450,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _categoryCard(
                                    'food', '식사', CustomColors.meal, '2meal'),
                                _categoryCard('singer', '문화활동',
                                    CustomColors.culture, '4culture'),
                                _categoryCard('filter-file', '기타',
                                    CustomColors.etc, '6etc'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _categoryCard(String icon, String text, Color color, String category) {
    return GestureDetector(
      onTap: () {
        controller.changeCategory(category);
        Get.back();
      },
      child: Container(
        width: Get.width * 0.3,
        height: Get.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/$icon.png',
              width: 60,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          PngIcon(
            iconName: 'location-pin',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              // Todo: 위치 추천 기능은 추후 제공 예정
              // child: LocationTextField(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller.locationController,
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    color: CustomColors.blackText,
                    fontSize: 18,
                  ),
                  cursorColor: CustomColors.darkGrey,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: '위치',
                    counterText: '',
                    hintStyle: TextStyle(
                      color: CustomColors.greyText,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          PngIcon(
            iconName: 'calendar',
            iconColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.datePicker(context);
                          },
                          child: Text(
                            controller.listDateTime.value == null
                                ? '예상 날짜'
                                : DateFormat('yyyy-MM-dd')
                                    .format(controller.listDateTime.value!),
                            style: TextStyle(
                              color: controller.listDateTime.value == null
                                  ? CustomColors.greyText
                                  : CustomColors.blackText,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      controller.listDateTime.value != null
                          ? GestureDetector(
                              onTap: () {
                                controller.listDateTime.value = null;
                                //    print(controller.listDateTime.value);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: CustomColors.grey,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentTextField(context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: Get.height - 480 - 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller.contentController,
        focusNode: controller.contentFocusNode,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (value) {},
        style: TextStyle(
          color: CustomColors.blackText,
          fontSize: 18,
          height: 1.2,
          fontFamily: 'Bookk_mj',
        ),
        cursorColor: CustomColors.darkGrey,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: '계획을 작성해 주세요',
          hintStyle: TextStyle(
            color: CustomColors.greyText,
            fontSize: 18,
            fontFamily: 'Bookk_mj',
          ),
        ),
      ),
    );
  }

  Widget _imageSelectors(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
        left: 30,
        right: 30,
      ),
      child: controller.selectedBukkungListModel == null
          ? Column(
              children: [
                Row(
                  children: [
                    _publicSwitch(),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _imagePicker(context),
                    SizedBox(width: 10),
                    _autoImageSwitch(),
                  ],
                ),
              ],
            )
          : _imagePicker(context),
    );
  }

  Widget _imagePicker(BuildContext context) {
    return Obx(() {
      return Container(
        height: 45,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: controller.imageType.value == ImageType.storageOnlineImage ||
                  controller.imageType.value == ImageType.storageOfflineImage
              ? CustomColors.mainPink.withOpacity(0.8)
              : Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            controller.pickImageFromGallery(context);
          },
          child: Center(
            child: PngIcon(
              iconName: 'image',
              iconColor: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      );
    });
  }

  Widget _autoImageSwitch() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              '추천 이미지 자동 추가',
              maxLines: 2,
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 15,
              ),
            ),
            Obx(() {
              return Switch(
                inactiveThumbColor: CustomColors.grey,
                value: controller.isAutoImage.value,
                onChanged: (value) {
                  controller.isAutoImage.value = value;
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _publicSwitch() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              '버꿍리스트 공개 여부',
              maxLines: 2,
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 15,
              ),
            ),
            Obx(() {
              return Switch(
                inactiveThumbColor: CustomColors.grey,
                value: controller.isPublic.value,
                onChanged: (value) {
                  controller.isPublic.value = value;
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(
      () => GestureDetector(
        onTap: controller.isCompleted.value == true
            ? () async {
                print('업로드 시작(upl page)');
                controller.isUploading.value = true;
                controller.sendCompletedMessageToBuddy();
                await controller.uploadBukkungList();
                Get.back();
                Get.back();
              }
            : () {
                if (controller.titleController.text == '') {
                  openAlertDialog(title: '제목을 입력해 주세요');
                } else if (controller.listCategory.value == '') {
                  openAlertDialog(title: '카테고리를 선택해주세요');
                } else if (controller.locationController.text == '') {
                  openAlertDialog(title: '위치를 작성해주세요');
                }
                // else if (controller.listDateTime.value == null) {
                //   openAlertDialog(title: '날짜를 선택해주세요');
                // }
                else if (controller.contentController == '') {
                  openAlertDialog(title: '세부 계획을 작성해주세요');
                }
              },
        child: Container(
          width: Get.width - 40,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: controller.selectedBukkungListModel == null
                ? controller.isCompleted.value == true
                    ? CustomColors.mainPink
                    : CustomColors.lightGrey.withOpacity(0.4)
                : controller.isSuggestion == true
                    ? controller.isCompleted.value == true
                        ? CustomColors.mainPink
                        : CustomColors.lightGrey.withOpacity(0.4)
                    : controller.isCompleted.value == true
                        ? CustomColors.mainPink
                        : CustomColors.lightGrey.withOpacity(0.4),
          ),
          child: Center(
            child: controller.selectedBukkungListModel == null
                ? controller.isCompleted.value == true
                    ? Text('저장', style: TextStyle(color: Colors.white))
                    : Text(
                        '저장',
                        style: TextStyle(color: Colors.white),
                      )
                : controller.isSuggestion == true
                    ? controller.isCompleted.value == true
                        ? Text('내 버꿍에 추가',
                            style: TextStyle(color: Colors.white))
                        : Text(
                            '내 버꿍에 추가',
                            style: TextStyle(color: Colors.white),
                          )
                    : controller.isCompleted.value == true
                        ? Text('수정 완료', style: TextStyle(color: Colors.white))
                        : Text(
                            '수정 완료',
                            style: TextStyle(color: Colors.white),
                          ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.backgroundLightGrey,
          appBar: _appBar(),
          body: KeyboardDismissOnTap(
            child: Stack(
              children: [
                Column(
                  children: [
                    // _titleTextField(),
                    SizedBox(height: 70),
                    customDivider(),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller.contentScrollController,
                        child: Column(
                          children: [
                            _categorySelector(context),
                            _locationTextfield(context),
                            _datePicker(context),
                            _contentTextField(context),
                            _imageSelectors(context),
                            _bottomBar(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // _searchResult(),
                _titleTextField(),
              ],
            ),
          ),
        ),
        Obx(
          () => controller.isUploading.value
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.mainPink,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the widget tree
    controller.dispose();
    super.dispose();
  }
}
