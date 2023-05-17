import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadBukkungListController extends GetxController {
  // late BuildContext context;
  // UploadBukkungListController({required this.context});

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  TextEditingController contentController = TextEditingController();

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

  List<AutoCompletePrediction> placePredictions = [];

  @override
  void onInit() {
    super.onInit();
    listCategory.value = "";
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
}
