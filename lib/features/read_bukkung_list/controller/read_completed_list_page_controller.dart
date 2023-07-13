import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:get/get.dart';

class ReadCompletedListPageController extends GetxController {
  final BukkungListModel bukkungListModel = Get.arguments;

  final Rx<String> imgUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    imgUrl(bukkungListModel.imgUrl);
  }
}
