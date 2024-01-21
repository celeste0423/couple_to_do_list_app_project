import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/diary_page_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/my_page_controller.dart';
import 'package:couple_to_do_list_app/features/list_suggestion/controller/list_suggestion_page_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }

  static additionalBinding() {
    Get.put(BukkungListPageController(), permanent: true);
    // Get.put(GgomulPageController(), permanent: true);
    Get.put(ListSuggestionPageController(), permanent: true);
    Get.put(DiaryPageController(), permanent: true);
    Get.put(MyPageController(), permanent: true);
  }

  void refreshControllers() {
    Get.delete<BukkungListPageController>();
    // Get.delete<GgomulPageController>();
    Get.delete<ListSuggestionPageController>();
    Get.delete<DiaryPageController>();
    Get.delete<MyPageController>();

    Get.put(BukkungListPageController(), permanent: true);
    // Get.put(GgomulPageController(), permanent: true);
    Get.put(ListSuggestionPageController(), permanent: true);
    Get.put(DiaryPageController(), permanent: true);
    Get.put(MyPageController(), permanent: true);
  }
}
