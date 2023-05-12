import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UploadBukkungListController extends GetxController {
  TextEditingController titleController = TextEditingController();

  Rx<String?> listCategory = null.obs;
  Map<String, String> categoryToString = {
    "category": "카테고리 별",
    "date": "날짜 순",
    "like": "좋아요 순",
  };

  @override
  void onInit() {
    super.onInit();
    listCategory.value = null;
    // myGroup(AuthController.to.group.value);
  }
}
