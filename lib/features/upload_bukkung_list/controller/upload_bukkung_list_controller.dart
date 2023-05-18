import 'dart:typed_data';

import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/image_picker_page.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadBukkungListController extends GetxController {
  static UploadBukkungListController get to => Get.find();

  TextEditingController? titleController = TextEditingController();

  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "travel": "여행",
    "meal": "식사",
    "activity": "액티비티",
    "culture": "문화 활동",
    "study": "자기 계발",
    "etc": "기타",
  };

  TextEditingController? locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  List<AutoCompletePrediction> placePredictions = [];

  Rx<DateTime?> listDateTime = Rx<DateTime?>(null);

  TextEditingController? contentController = TextEditingController();
  ScrollController contentScrollController = ScrollController();

  Uint8List? listImage = null;
  Rx<bool> isImage = false.obs;

  Rx<bool> isPublic = true.obs;

  @override
  void onInit() {
    super.onInit();
    listCategory.value = "";
    titleController = null;
    locationController = null;
    contentController = null;

    contentScrollController.addListener(scrollToContent);
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
                  primary: Colors.white,
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
      print('선택한 이미지가 없습니다');
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
}
