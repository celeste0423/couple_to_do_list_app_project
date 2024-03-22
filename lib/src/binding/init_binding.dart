import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/features/bukkung_list/controllers/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/diary/controllers/diary_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/my/controller/my_page_controller.dart';
import 'package:couple_to_do_list_app/src/features/suggestion_list/controller/suggestion_list_page_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }

  static additionalBinding() {
    Get.put(BukkungListPageController(), permanent: true);
    // Get.put(GgomulPageController(), permanent: true);
    Get.put(SuggestionListPageController());
    Get.put(DiaryPageController(), permanent: true);
    Get.put(MyPageController(), permanent: true);
  }

  // void refreshControllers() {
  //   Get.delete<BukkungListPageController>();
  //   // Get.delete<GgomulPageController>();
  //   Get.delete<ListSuggestionPageController>();
  //   Get.delete<DiaryPageController>();
  //   Get.delete<MyPageController>();
  //
  //   Get.put(BukkungListPageController(), permanent: true);
  //   // Get.put(GgomulPageController(), permanent: true);
  //   Get.put(ListSuggestionPageController(), permanent: true);
  //   Get.put(DiaryPageController(), permanent: true);
  //   Get.put(MyPageController(), permanent: true);
  // }
}
