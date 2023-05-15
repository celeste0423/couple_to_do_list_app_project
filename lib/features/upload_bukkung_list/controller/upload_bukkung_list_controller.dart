import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UploadBukkungListController extends GetxController {
  TextEditingController titleController = TextEditingController();

  static UploadBukkungListController get to => Get.find();

  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "travel": "여행",
    "meal": "식사",
    "activity": "액티비티",
    "culture": "문화 활동",
    "study": "자기 계발",
    "etc": "기타",
  };

  @override
  void onInit() {
    super.onInit();
    listCategory.value = "";
  }

  void changeCategory(String category) {
    listCategory(category);
  }
}
