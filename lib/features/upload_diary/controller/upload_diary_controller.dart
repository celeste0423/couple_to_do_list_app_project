import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDiaryController extends GetxController {
  TextEditingController? titleController = TextEditingController();
  TextEditingController? locationController = TextEditingController();
 // final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  TextEditingController? contentController = TextEditingController();

  static UploadDiaryController get to => Get.find();

  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "travel": "여행",
    "meal": "식사",
    "activity": "액티비티",
    "culture": "문화 활동",
    "study": "자기 계발",
    "etc": "기타",
  };
  Rx<DateTime?> listDateTime = Rx<DateTime?>(null);
  List<AutoCompletePrediction> placePredictions = [];

  @override
  void onInit() {
    super.onInit();

  }
}
