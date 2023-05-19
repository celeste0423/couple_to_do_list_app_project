import 'dart:typed_data';

import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/image_picker_page.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class UploadBukkungListController extends GetxController {
  static UploadBukkungListController get to => Get.find();

  Rx<bool> isCompleted = false.obs;

  TextEditingController titleController = TextEditingController();

  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "travel": "여행",
    "meal": "식사",
    "activity": "액티비티",
    "culture": "문화 활동",
    "study": "자기 계발",
    "etc": "기타",
  };

  TextEditingController locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  List<AutoCompletePrediction> placePredictions = [];

  Rx<DateTime?> listDateTime = Rx<DateTime?>(null);

  TextEditingController contentController = TextEditingController();
  ScrollController contentScrollController = ScrollController();

  Uint8List? listImage = null;
  Rx<bool> isImage = false.obs;

  Rx<bool> isPublic = true.obs;
  BukkungListModel? bukkungList;

  @override
  void onInit() {
    super.onInit();

    _checkCompleted();
    titleController.addListener(_checkCompleted);
    listCategory.listen((_) {
      _checkCompleted();
    });
    locationController.addListener(_checkCompleted);
    listDateTime.listen((_) {
      _checkCompleted();
    });
    contentController.addListener(_checkCompleted);

    contentScrollController.addListener(scrollToContent);
    bukkungList = BukkungListModel.init(AuthController.to.user.value);
  }

  void _checkCompleted() {
    if (titleController.text.isNotEmpty &&
        listCategory.value!.isNotEmpty &&
        locationController.text.isNotEmpty &&
        listDateTime.value != null &&
        contentController.text.isNotEmpty) {
      isCompleted.value = true;
    } else {
      isCompleted.value = false;
    }
  }

  void changeCategory(String category) {
    listCategory(category);
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
                ))),
            child: child!,
          );
        });
    if (selectedDate != null) {
      listDateTime(selectedDate);
    }
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

  void pickImageFromGallery(BuildContext context) async {
    final image = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImagePickerPage()));
    if (image == null) {
      print('선택한 이미지가 없습니다(upl cont)');
      isImage(false);
      return;
    }
    isImage(true);
    listImage = image;
  }

// Future pickImageFromCamera(BuildContext context) async {
//   Navigator.of(context).pop();
//   try {
//     final image = await ImagePicker().pickImage(source: ImageSource.camera);
//     imageCamera = File(image!.path);
//     imageGallery = null;
//   } catch (e) {
//     openAlertDialog(content: e.toString(), title: '오류');
//   }
// }

  void uploadBukkungList() {
    FocusManager.instance.primaryFocus?.unfocus();
    var uuid = Uuid();
    String listId = uuid.v1();
    String imageId = uuid.v4();

    var filename = '$imageId.jpg';
    if (listImage != null) {
      print('업로드 준비 완료(upl cont)');
      var task = uploadFile(
          listImage!, '${AuthController.to.user.value.groupId}/${filename}');
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          print('업로드 시작 (upl cont)');
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedBukkungList = bukkungList!.copyWith(
            listId: listId,
            category: listCategory.value,
            title: titleController.text,
            content: contentController.text,
            location: locationController.text,
            imgUrl: downloadUrl,
            date: listDateTime.value,
          );
          _submitBukkungList(updatedBukkungList, listId);
        }
      });
    } else {
      var updatedBukkungList = bukkungList!.copyWith(
        listId: listId,
        category: listCategory.value,
        title: titleController.text,
        content: contentController.text,
        location: locationController.text,
        //꼬물이 사진 기본 사진으로
        imgUrl:
            "https://firebasestorage.googleapis.com/v0/b/bukkunglist.appspot.com/o/bukkung_list%2F67b9ade0-ee36-11ed-b243-2f79762c93de%2FClosure%3A%20(%7BMap%3CString%2C%20dynamic%3E%3F%20options%7D)%20%3D%3E%20String%20from%20Function%20'v4'%3A..jpg?alt=media&token=f8db7acb-8888-4ca6-97f9-0a6ab237055d",
        likeCount: 0,
        date: listDateTime.value,
        madeBy: AuthController.to.user.value.nickname,
        userId: AuthController.to.user.value.uid,
        groupId: AuthController.to.user.value.groupId,
      );
      _submitBukkungList(updatedBukkungList, listId);
    }
  }

  UploadTask uploadFile(Uint8List image, String filename) {
    var ref =
        FirebaseStorage.instance.ref().child('bukkung_list').child(filename);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );
    return ref.putData(image, metadata);
  }

  void _submitBukkungList(
      BukkungListModel bukkungListData, String listId) async {
    await BukkungListRepository.setGroupBukkungList(bukkungListData, listId);
    if (isPublic.value == true) {
      print('추천 리스트 공개 업로드(upl cont)');
      await BukkungListRepository.setSuggestionBukkungList(
          bukkungListData, listId);
    }
  }
}
