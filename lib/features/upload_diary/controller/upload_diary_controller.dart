import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/image_picker_page.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

//Todo: onDelete 함수 어떻게 불러오는거징
class UploadDiaryController extends GetxController {
  static UploadDiaryController get to => Get.find();

  Uint8List? diaryImage = null;
  Rx<bool> isImage = false.obs;

// todo: 다이어리 모델 둘중에 뭐 쓸까
  final DiaryModel? selectedDiaryModel = Get.arguments;
  DiaryModel? diary;

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
    if (selectedDiaryModel != null) {
      titleController.text = selectedDiaryModel!.title!;
      diaryCategory(selectedDiaryModel!.category!);
      diaryDateTime(selectedDiaryModel!.date);
      if (selectedDiaryModel!.location != null) {
        locationController.text = selectedDiaryModel!.location!;
      }
      if (selectedDiaryModel!.mySogam != null) {
        contentController.text = selectedDiaryModel!.mySogam!;
      }
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
        diaryCategory.value! != '' &&
        locationController.text.isNotEmpty &&
        diaryDateTime.value != null &&
        contentController.text.isNotEmpty) {
      return true;
    } else {
      print(diaryDateTime.value);
      return false;
    }
  }

  UploadTask uploadFile(Uint8List image, String location, String filename) {
    var ref = FirebaseStorage.instance.ref().child(location).child(filename);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );
    return ref.putData(image, metadata);
  }

  void pickImageFromGallery(BuildContext context) async {
    final image = await Get.to(ImagePickerPage());
    if (image == null) {
      print('선택한 이미지가 없습니다(upl cont)');
      isImage(false);
      return;
    }
    isImage(true);
    //todo: 이거 매커니즘 파악 해야 될듯 uint8list가 뭔지...
    diaryImage = image;
  }

  Future<void> submitDiary(DiaryModel diaryData, String diaryId) async {
    await DiaryRepository.setGroupDiary(diaryData, diaryId);
  }

  Future<void> uploadDiary() async {
    var uuid = Uuid();
    String diaryId = uuid.v1();
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';
    //diaryImage list 에 사진이 있으면
    if (diaryImage != null) {
      print('다이어리 사진 있음(로컬)');
      var task = uploadFile(diaryImage!, 'group_diary',
          '${AuthController.to.user.value.groupId}/${filename}');
      //task 완료 하면 submitdiary 되도록
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          print('업로드 시작 (upl cont)');
          var downloadUrl = await event.ref.getDownloadURL();
          if (selectedDiaryModel != null) {
            //기존 다이어리 수정할 경우
            DiaryModel updatedDiary = selectedDiaryModel!.copyWith(
              title: titleController.text,
              category: diaryCategory.value,
              location: locationController.text,
              //todo: imgUrlList: diaryImage ?? null,
              mySogam: contentController.text,
              bukkungSogam: selectedDiaryModel == null
                  ? null
                  : selectedDiaryModel!.bukkungSogam,
              date: diaryDateTime.value,
              // 여긴selectedDiaryModel null 아닐때만이니까 이미 creatorUserID,createdAt 존재 함.
              lastUpdatorID: AuthController.to.user.value.uid,
              updatedAt: DateTime.now(),
            );
            submitDiary(updatedDiary, diaryId);
          } else {
            //새로운 다이어리 작성 할 경우
            DiaryModel updatedDiary = DiaryModel(
              title: titleController.text,
              category: diaryCategory.value,
              location: locationController.text,
              //todo: imgUrlList: diaryImage ?? null,
              mySogam: contentController.text,
              bukkungSogam: selectedDiaryModel == null
                  ? null
                  : selectedDiaryModel!.bukkungSogam,
              date: diaryDateTime.value,
              createdAt: DateTime.now(),
              creatorUserID: AuthController.to.user.value.uid,
              lastUpdatorID: AuthController.to.user.value.uid,
              updatedAt: DateTime.now(),
            );
            submitDiary(updatedDiary, diaryId);
          }
        }
      });
    } else {
      //diaryImage list 에 아무것도 없으면(null) 이미지 없이 그냥 업로딩 한다
      if (selectedDiaryModel != null) {
        //기존 다이어리 수정할 경우
        DiaryModel updatedDiary = selectedDiaryModel!.copyWith(
          title: titleController.text,
          category: diaryCategory.value,
          location: locationController.text,
          //todo: imgUrlList: diaryImage ?? null,
          mySogam: contentController.text,
          bukkungSogam: selectedDiaryModel == null
              ? null
              : selectedDiaryModel!.bukkungSogam,
          date: diaryDateTime.value,
          // 여긴selectedDiaryModel null 아닐때만이니까 이미 creatorUserID,createdAt 존재 함.
          lastUpdatorID: AuthController.to.user.value.uid,
          updatedAt: DateTime.now(),
        );
        submitDiary(updatedDiary, diaryId);
      } else {
        //새로운 다이어리 작성 할 경우
        DiaryModel updatedDiary = DiaryModel(
          title: titleController.text,
          category: diaryCategory.value,
          location: locationController.text,
          //todo: imgUrlList: diaryImage ?? null,
          mySogam: contentController.text,
          bukkungSogam: selectedDiaryModel == null
              ? null
              : selectedDiaryModel!.bukkungSogam,
          date: diaryDateTime.value,
          createdAt: DateTime.now(),
          creatorUserID: AuthController.to.user.value.uid,
          lastUpdatorID: AuthController.to.user.value.uid,
          updatedAt: DateTime.now(),
        );
        submitDiary(updatedDiary, diaryId);
      }
    }
  }
}
