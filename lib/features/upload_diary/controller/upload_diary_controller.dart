import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Todo: onDelete 함수 어떻게 불러오는거징
class UploadDiaryController extends GetxController {
  Rx<DiaryModel> bukkungList = DiaryModel().obs;

  static UploadDiaryController get to => Get.find();

  final DiaryModel? selectedDiaryModel = Get.arguments;

  TextEditingController locationController = TextEditingController();
  List<AutoCompletePrediction> placePredictions = [];

  TextEditingController titleController = TextEditingController();

  TextEditingController contentController = TextEditingController();
  ScrollController contentScrollController = ScrollController();

  Rx<DateTime?> diaryDateTime = Rx<DateTime?>(null);

  Rx<String?> diaryCategory = "".obs;
  Map<String, String> categoryToString = {
    "1travel": "여행",
    "2meal": "식사",
    "3activity": "액티비티",
    "4culture": "문화 활동",
    "5study": "자기 계발",
    "6etc": "기타",
  };

  @override
  void onInit() {
    super.onInit();
    if(selectedDiaryModel!=null){
      titleController.text = selectedDiaryModel!.title!;
      diaryCategory(selectedDiaryModel!.category!);
      diaryDateTime(selectedDiaryModel!.date);
      if(selectedDiaryModel!.location != null){locationController.text = selectedDiaryModel!.location!;}
      if(selectedDiaryModel!.mySogam != null){contentController.text = selectedDiaryModel!.mySogam!;}
    }
    contentScrollController.addListener(scrollToContent);
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
      diaryDateTime(selectedDate);
    }
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

  void changeCategory(String category) {
    diaryCategory(category);
    print('changed category');
    print(diaryCategory);
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

  bool isValid() {
    if (titleController.text.isNotEmpty &&
        diaryCategory.value! !='' &&
        locationController.text.isNotEmpty &&
        diaryDateTime.value != null &&
        contentController.text.isNotEmpty ) {
      return true;
    } else {
      print(diaryDateTime.value);
      return false;
    }
  }

  void uploadDiary() {}
}
