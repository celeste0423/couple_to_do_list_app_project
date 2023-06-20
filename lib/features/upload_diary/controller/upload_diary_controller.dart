import 'dart:io';

import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

//Todo: onDelete 함수 어떻게 불러오는거징
class UploadDiaryController extends GetxController {
  static UploadDiaryController get to => Get.find();

  Uint8List? diaryImage = null;

  // Rx<bool> isImage = false.obs;

// todo: 다이어리 모델 둘중에 뭐 쓸까
  final DiaryModel? selectedDiaryModel = Get.arguments;
  DiaryModel? diary;

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

  RxList<File> selectedImages = <File>[].obs; // List of selected image
  final picker = ImagePicker(); // Instance of Image picker

  bool isButtonDisabled = false;

  @override
  void onInit() {
    super.onInit();
    print('selectedDiaryModelargument : $selectedDiaryModel');
    if (selectedDiaryModel != null) {
      titleController.text = selectedDiaryModel!.title!;
      diaryCategory(selectedDiaryModel!.category!);
      diaryDateTime(selectedDiaryModel!.date);
      if (selectedDiaryModel!.location != null) {
        locationController.text = selectedDiaryModel!.location!;
      }
      if (selectedDiaryModel!.creatorSogam != null) {
        contentController.text = selectedDiaryModel!.creatorSogam!;
      }
    }
    contentScrollController.addListener(scrollToContent);
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
                  primary: Colors.white,
                ))),
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
    print('changed category');
    print(diaryCategory);
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
    print('pickMultipleImages function start');
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, // To set quality of images
        maxHeight: 1000, // To set maxheight of images that you want in your app
        maxWidth: 1000); // To set maxheight of images that you want in your app
    List<XFile> xfilePick = pickedFile;

    // if atleast 1 images is selected it will add
    // all images in selectedImages
    // variable so that we can easily show them in UI
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      print(selectedImages[0].path);
      print(selectedImages.length);
    } else {
      // If no image is selected it will show a
      // snackbar saying nothing is selected
      Get.snackbar('사진 고르기 취소', 'Nothing is selected');
    }
  }

  Future<void> submitDiary(DiaryModel diaryData, String diaryId) async {
    await DiaryRepository.setGroupDiary(diaryData, diaryId);
  }

  UploadTask uploadFile(File file, String location, String filename) {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );
    var ref = FirebaseStorage.instance
        .ref()
        .child('group_diary')
        .child('${AuthController.to.user.value.groupId}/${filename}');
    return ref.putFile(file, metadata);
  }

  uploadSelectedImages(String imageId) async {
    List<String> addimgurllist = <String>[];
    for (var i = 0; i < selectedImages.length; i++) {
      String filename = imageId + i.toString() + '.jpg';
      var uploadTask = await FirebaseStorage.instance
          .ref()
          .child('group_diary')
          .child('${AuthController.to.user.value.groupId}/${filename}')
          .putFile(selectedImages[i]);
      var downloadUrl = await uploadTask.ref.getDownloadURL();
      print('this is the url : $downloadUrl');
      addimgurllist.add(downloadUrl);
    }
    return addimgurllist;
  }

  makeAndSubmitDiary(String diaryId, List<String> addImgUrlList) {
    if (selectedDiaryModel != null) {
      //기존 다이어리 수정할 경우
      DiaryModel updatedDiary = selectedDiaryModel!.copyWith(
        title: titleController.text,
        category: diaryCategory.value,
        location: locationController.text,
        imgUrlList: selectedDiaryModel!.imgUrlList! + addImgUrlList,
        creatorSogam: contentController.text,
        bukkungSogam: selectedDiaryModel == null
            ? null
            : selectedDiaryModel!.bukkungSogam,
        date: diaryDateTime.value,
        // 여긴selectedDiaryModel null 아닐때만이니까 이미 creatorUserID,createdAt 존재 함.
        lastUpdatorID: AuthController.to.user.value.uid,
        updatedAt: DateTime.now(),
        diaryId: diaryId,
      );
      submitDiary(updatedDiary, diaryId);
    } else {
      //새로운 다이어리 작성 할 경우
      print(addImgUrlList);
      print('바로위 리스트가 addImgUrlList에요');
      DiaryModel updatedDiary = DiaryModel(
        title: titleController.text,
        category: diaryCategory.value,
        location: locationController.text,
        imgUrlList: addImgUrlList,
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
    }
  }

  Future uploadDiary() async {
    var uuid = Uuid();
    //기존 다이어리 수정의 경우 기존 diaryId 사용하면 됨.
    String diaryId =
        selectedDiaryModel != null ? selectedDiaryModel!.diaryId! : uuid.v1();
    String imageId = uuid.v4();
    List<String> addImgUrlList = [];
    //selectedImages 에 사진file이 있으면
    if (selectedImages.isNotEmpty) {
      print('다이어리 사진 있음(로컬)');
      addImgUrlList = await uploadSelectedImages(imageId);
      print('사진 업로드 완료, addImgUrlList = $addImgUrlList');
    } //selectedImages 에 아무것도 없으면(null) 이미지 없이 그냥 diary 업로딩 한다
    await makeAndSubmitDiary(diaryId, addImgUrlList);
    print('Diary 업로드 완료');
  }
}
