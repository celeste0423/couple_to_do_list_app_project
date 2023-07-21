import 'dart:io';

import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

//Todo: onDelete 함수 어떻게 불러오는거징
class UploadDiaryController extends GetxController {
  static UploadDiaryController get to => Get.find();

  Uint8List? diaryImage = null;

  DiaryModel? selectedDiaryModel = Get.arguments;

  // Rx<DiaryModel?> selectedDiaryModel =
  //     (DiaryModel().copyDiaryModel(Get.arguments)).obs;

  TextEditingController locationController = TextEditingController();
  List<AutoCompletePrediction> placePredictions = [];

  TextEditingController titleController = TextEditingController();

  TextEditingController contentController = TextEditingController();
  ScrollController contentScrollController = ScrollController();

  Rx<DateTime?> diaryDateTime = Rx<DateTime?>(null);

  Rx<String?> diaryCategory = "".obs;
  Map<String, String> categoryToString = {
    "1travel": "여행",
    "2meal": "식사",
    "3activity": "액티비티",
    "4culture": "문화 활동",
    "5study": "자기 계발",
    "6etc": "기타",
  };

  List<RxList<dynamic>> selectedImgFiles = [<File>[].obs, <String?>[].obs];

  Rx<bool> isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIsDiarySelected();
    contentScrollController.addListener(scrollToContent);
  }

  void _checkIsDiarySelected() {
    if (selectedDiaryModel != null) {
      titleController.text = selectedDiaryModel!.title!;
      diaryCategory(selectedDiaryModel!.category!);
      diaryDateTime(selectedDiaryModel!.date);
      locationController.text = selectedDiaryModel!.location!;
      if(selectedDiaryModel!.creatorUserID == AuthController.to.user.value.uid)
      {contentController.text = selectedDiaryModel!.creatorSogam!;}
      else{contentController.text = selectedDiaryModel!.bukkungSogam ?? '';}
      if (selectedDiaryModel!.imgUrlList != []) {
        _addNetworkImgToFile();
      }
    }
  }

  Future<void> _addNetworkImgToFile() async {
    final storage = FirebaseStorage.instance;
    for (final imgUrl in selectedDiaryModel!.imgUrlList!) {
      //임시 경로 지정
      var uuid = Uuid();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${uuid.v4()}.jpg';
      print('tempPath $tempPath');
      try {
        await storage.refFromURL(imgUrl).writeToFile(File(tempPath));
      } catch (e) {
        print(e.toString());
      }

      final imgFile = File(tempPath);

      selectedImgFiles[0].add(imgFile);
      selectedImgFiles[1].add(imgUrl);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    locationController.dispose();
    contentController.dispose();
    contentScrollController.dispose();
  }

  void datePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        locale: const Locale('ko', ''),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.white,
                onPrimary: CustomColors.mainPink,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            child: child!,
          );
        });
    if (selectedDate != null) {
      diaryDateTime(selectedDate);
    }
  }

  void placeAutocomplete(String query) async {
    String apiKey = 'AIzaSyASuuGiXo0mFRd2jm_vL5mHBo4r4uCTJZw';
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": apiKey,
      "language": "ko",
      "components": "country:kr",
    });
    String? response = await LocationNetworkUtil.fetchUrl(uri);

    if (response != null) {
      PlaceAutoCompleteResponse result =
          PlaceAutoCompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        placePredictions = result.predictions!;
      }
    }
  }

  void changeCategory(String category) {
    diaryCategory(category);
  }

  void scrollToContent() {
    if (contentScrollController.hasClients) {
      contentScrollController.animateTo(
        contentScrollController.position.maxScrollExtent - 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool isValid() {
    if (titleController.text.isNotEmpty &&
        diaryCategory.value! != '' &&
        locationController.text.isNotEmpty &&
        diaryDateTime.value != null &&
        contentController.text.isNotEmpty) {
      return true;
    } else {
      print(diaryDateTime.value);
      return false;
    }
  }

  Future pickMultipleImages() async {
    int maxImageCount = 5;
    final pickerImgList = await ImagePicker().pickMultiImage(
      imageQuality: 50, // To set quality of images
      maxHeight: 500, // To set maxheight of images that you want in your app
      maxWidth: 500,
    ); // To set maxheight of images that you want in your app
    if (pickerImgList.isNotEmpty) {
      if (pickerImgList.length > maxImageCount) {
        // 이미지 개수가 최대 개수보다 많을 경우 경고 메시지 출력
        openAlertDialog(
          title: '이미지 개수 초과',
          content: '최대 $maxImageCount개의 이미지를 선택할 수 있습니다.',
        );
        return; // 이미지 선택 종료
      }
      for (var pickerImgIndex = 0;
          pickerImgIndex < pickerImgList.length;
          pickerImgIndex++) {
        selectedImgFiles[0].add(File(pickerImgList[pickerImgIndex].path));
        selectedImgFiles[1].add(null);
      }
    } else {
      openAlertDialog(
        title: '이미지 선택 없음',
        content: '선택된 이미지가 없습니다.',
      );
    }
  }

  Future<void> submitDiary(DiaryModel diaryData, String diaryId) async {
    await DiaryRepository.setGroupDiary(diaryData, diaryId);
  }

  uploadSelectedImages() async {
    List<String> imgUrlList = <String>[];
    var uuid = Uuid();

    for (var imgIndex = 0; imgIndex < selectedImgFiles[0].length; imgIndex++) {
      if (selectedImgFiles[1][imgIndex] == null) {
        //새로 업로드할 이미지 => 업로드
        String imageId = uuid.v4();
        String filename = '$imageId.jpg';
        var uploadTask = await FirebaseStorage.instance
            .ref()
            .child('group_diary')
            .child('${AuthController.to.user.value.groupId}/${filename}')
            .putFile(selectedImgFiles[0][imgIndex]);
        var downloadUrl = await uploadTask.ref.getDownloadURL();
        imgUrlList.add(downloadUrl);
      } else {
        imgUrlList.add(selectedImgFiles[1][imgIndex]);
      }
    }
    return imgUrlList;
  }

  Future<DiaryModel> makeAndSubmitDiary(String diaryId, List<String> imgUrlList) async {
    if (selectedDiaryModel != null) {
      //기존 다이어리 수정할 경우
      for (String imgUrl in selectedDiaryModel!.imgUrlList!) {
        //기존에 있던 이미지를 이번엔 안 올릴경우
        if (!imgUrlList.contains(imgUrl)) {
          //스토리지에서 이미지 제거
          await DiaryRepository().deleteDiaryImage(imgUrl);
        }
      }
      DiaryModel updatedDiary = selectedDiaryModel!.copyWith(
               title: titleController.text,
        category: diaryCategory.value,
        location: locationController.text,
        imgUrlList: imgUrlList,
        creatorSogam: AuthController.to.user.value.uid == selectedDiaryModel!.creatorUserID ? contentController.text: selectedDiaryModel!.creatorSogam,
        bukkungSogam: AuthController.to.user.value.uid == selectedDiaryModel!.creatorUserID ? selectedDiaryModel!.bukkungSogam: contentController.text,
        date: diaryDateTime.value,
        // 여긴selectedDiaryModel null 아닐때만이니까 이미 creatorUserID,createdAt 존재 함.
        lastUpdatorID: AuthController.to.user.value.uid,
        updatedAt: DateTime.now(),
        diaryId: diaryId,
      );
      submitDiary(updatedDiary, diaryId);
      return updatedDiary;
    } else {
      //새로운 다이어리 작성 할 경우
      DiaryModel updatedDiary = DiaryModel(
        title: titleController.text,
        category: diaryCategory.value,
        location: locationController.text,
        imgUrlList: imgUrlList,
        creatorSogam: contentController.text,
        bukkungSogam: selectedDiaryModel == null
            ? null
            : selectedDiaryModel!.bukkungSogam,
        date: diaryDateTime.value,
        createdAt: DateTime.now(),
        creatorUserID: AuthController.to.user.value.uid,
        lastUpdatorID: AuthController.to.user.value.uid,
        updatedAt: DateTime.now(),
        diaryId: diaryId,
      );
      submitDiary(updatedDiary, diaryId);
      return updatedDiary;
    }
  }

  Future<DiaryModel> uploadDiary() async {
    var uuid = Uuid();
    //기존 다이어리 수정의 경우 기존 diaryId 사용하면 됨.
    String diaryId =
        selectedDiaryModel != null ? selectedDiaryModel!.diaryId! : uuid.v1();
    List<String> imgUrlList = [];
    //selectedImages 에 사진file이 있으면
    if (selectedImgFiles.isNotEmpty) {
      imgUrlList = await uploadSelectedImages();
    } //selectedImages 에 아무것도 없으면(null) 이미지 없이 그냥 diary 업로딩 한다
    DiaryModel updatedDiary = await makeAndSubmitDiary(diaryId, imgUrlList);
    return updatedDiary;
  }

}
