import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadBukkungListController extends GetxController {
  late BuildContext context;
  UploadBukkungListController({required this.context});

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;

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

    locationFocusNode.addListener(() {
      if (locationFocusNode.hasFocus) {
        overlayEntry = createOverlayEntry(context!);
        Overlay.of(context!).insert(overlayEntry!);
      } else {
        overlayEntry!.remove();
      }
    });
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

  OverlayEntry createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    print('추천 검색어 길이 (upl cont)${placePredictions.length}');
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          child: placePredictions.length == 0
              ? Container(
                  color: Colors.red,
                  height: 50,
                  width: 50,
                )
              : ListView.builder(
                  itemCount: placePredictions.length,
                  itemBuilder: (context, index) {
                    return _locationListTile(
                      placePredictions[index].description,
                      () {},
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _locationListTile(String? location, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          title: Text(
            location ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: CustomColors.grey,
        )
      ],
    );
  }
}
