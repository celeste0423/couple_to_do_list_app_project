import 'dart:typed_data';

import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/pages/image_picker_page.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class UploadBukkungListController extends GetxController {
  static UploadBukkungListController get to => Get.find();

  final BukkungListModel? selectedBukkungListModel = Get.arguments[0];
  final bool isSuggestion = Get.arguments[1];

  Rx<bool> isCompleted = false.obs;

  TextEditingController titleController = TextEditingController();

  Rx<String?> listCategory = "".obs;
  Map<String, String> categoryToString = {
    "1travel": "여행",
    "2meal": "식사",
    "3activity": "액티비티",
    "4culture": "문화 활동",
    "5study": "자기 계발",
    "6etc": "기타",
  };

  TextEditingController locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();
  OverlayEntry? overlayEntry;
  List<AutoCompletePrediction> placePredictions = [];

  Rx<DateTime?> listDateTime = Rx<DateTime?>(null);

  TextEditingController contentController = TextEditingController();
  ScrollController contentScrollController = ScrollController();

  Uint8List? listImage;

  Rx<bool> isImage = false.obs;
  Rx<bool> isSelectedImage = false.obs;

  Rx<bool> isPublic = true.obs;
  BukkungListModel? bukkungList;

  Rx<bool> isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIsBukkungListSelected();
    _checkCompleted();
    titleController.addListener(_checkCompleted);
    listCategory.listen((_) {
      _checkCompleted();
    });
    locationController.addListener(_checkCompleted);
    listDateTime.listen((_) {
      _checkCompleted();
    });
    contentController.addListener(_checkCompleted);

    contentScrollController.addListener(scrollToContent);
    bukkungList = BukkungListModel.init(AuthController.to.user.value);
  }

  void _checkIsBukkungListSelected() {
    if (selectedBukkungListModel != null) {
      titleController.text = selectedBukkungListModel!.title!;
      listCategory(selectedBukkungListModel!.category!);
      locationController.text = selectedBukkungListModel!.location!;
      if (isSuggestion == false) {
        listDateTime(selectedBukkungListModel!.date);
      }
      contentController.text = selectedBukkungListModel!.content!;
      isPublic(false);
      if (selectedBukkungListModel!.imgUrl == Constants.baseImageUrl) {
        print('사진 없음(upl cont) ${selectedBukkungListModel!.imgUrl}');
        isSelectedImage(false);
      } else {
        print('사진 있음(upl cont');
        isSelectedImage(true);
      }
    }
  }

  void _checkCompleted() {
    if (titleController.text.isNotEmpty &&
        listCategory.value!.isNotEmpty &&
        locationController.text.isNotEmpty &&
        listDateTime.value != null &&
        contentController.text.isNotEmpty) {
      isCompleted.value = true;
    } else {
      isCompleted.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    locationController.dispose();
    contentController.dispose();
    contentScrollController.dispose();
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
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      listDateTime(selectedDate);
    }
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

  void pickImageFromGallery(BuildContext context) async {
    final image = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImagePickerPage()));
    if (image == null) {
      print('선택한 이미지가 없습니다(upl cont)');
      isImage(false);
      return;
    }
    isImage(true);
    listImage = image;
  }

  Future<void> uploadBukkungList() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var uuid = Uuid();
    String listId = uuid.v1();
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';

    if (selectedBukkungListModel == null && listImage != null) {
      //선택 안함, 사진 있음
      var task = uploadFile(listImage!, 'group_bukkunglist',
          '${AuthController.to.user.value.groupId}/${filename}');

      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedBukkungList = bukkungList!.copyWith(
            listId: listId,
            category: listCategory.value,
            title: titleController.text,
            content: contentController.text,
            location: locationController.text,
            imgUrl: downloadUrl,
            imgId: imageId,
            date: listDateTime.value,
          );
          _submitBukkungList(updatedBukkungList, listId, false);
        }
      });
    } else if (selectedBukkungListModel == null) {
      // 선택 안함, 사진 없음
      var updatedBukkungList = bukkungList!.copyWith(
        listId: listId,
        category: listCategory.value,
        title: titleController.text,
        content: contentController.text,
        location: locationController.text,
        imgUrl: Constants.baseImageUrl,
        likeCount: 0,
        date: listDateTime.value,
      );
      _submitNoImgBukkungList(updatedBukkungList, listId, false);
    } else if (selectedBukkungListModel != null &&
        isSelectedImage.value == true &&
        listImage == null) {
      // 선택함, 사진 있음(웹사진)
      print('선택함, 사진있음(웹사진)');
      String? downloadUrl;
      if (isSuggestion) {
        //수정중 => 이미지 주소 그대로 들고옴
        print('수정중 이미지 주소 그대로 들고옴');
        String sourcePath = '${selectedBukkungListModel!.imgId}.jpg';
        String destinationPath =
            '${AuthController.to.user.value.groupId}/$filename';
        Reference sourceRef = FirebaseStorage.instance
            .ref()
            .child('suggestion_bukkunglist')
            .child(sourcePath);
        Reference destinationRef = FirebaseStorage.instance
            .ref()
            .child('group_bukkunglist')
            .child(destinationPath);
        Uint8List? sourceData = await sourceRef.getData()!;
        await destinationRef.putData(sourceData!);

        downloadUrl = await destinationRef.getDownloadURL();
      } else {
        downloadUrl = selectedBukkungListModel!.imgUrl;
      }

      var updatedBukkungList = selectedBukkungListModel!.copyWith(
        listId: isSuggestion ? listId : selectedBukkungListModel!.listId,
        category: listCategory.value,
        title: titleController.text,
        content: contentController.text,
        location: locationController.text,
        imgUrl: downloadUrl,
        imgId: imageId,
        date: listDateTime.value,
        // Todo:기존 제작자의 저작권을 남길 지 말지 선택
      );
      if (isSuggestion) {
        _submitBukkungList(updatedBukkungList, listId, true);
      } else {
        //수정할 때는 리스트 업데이트 해줄 것
        _updateBukkungList(updatedBukkungList);
      }
    } else if (selectedBukkungListModel != null && listImage != null) {
      //선택함, 사진 있음(로컬사진)
      print('선택함, 사진있음(로컬사진)');
      if (!isSuggestion) {
        //수정중 => 기존 사진 삭제, 새 사진 업로드
        print('기존 사진 삭제');
        BukkungListRepository.deleteImage(selectedBukkungListModel!.imgUrl!);
      }
      var task = uploadFile(listImage!, 'group_bukkunglist',
          '${AuthController.to.user.value.groupId}/${filename}');
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedBukkungList = selectedBukkungListModel!.copyWith(
            listId: isSuggestion ? listId : selectedBukkungListModel!.listId,
            category: listCategory.value,
            title: titleController.text,
            content: contentController.text,
            location: locationController.text,
            imgUrl: downloadUrl,
            date: listDateTime.value,
          );
          if (isSuggestion) {
            _submitBukkungList(updatedBukkungList, listId, true);
          } else {
            //수정할 때는 리스트 업데이트 해줄 것
            _updateBukkungList(updatedBukkungList);
          }
        }
      });
    } else if (selectedBukkungListModel != null &&
        listImage == null &&
        isSelectedImage == false) {
      //선택함, 사진 없음(로컬, 웹 둘다)
      print('선택함, 사진없음');
      var updatedBukkungList = selectedBukkungListModel!.copyWith(
        listId: isSuggestion ? listId : selectedBukkungListModel!.listId,
        category: listCategory.value,
        title: titleController.text,
        content: contentController.text,
        location: locationController.text,
        imgUrl: Constants.baseImageUrl,
        date: listDateTime.value,
      );
      if (isSuggestion) {
        _submitBukkungList(updatedBukkungList, listId, true);
      } else {
        //수정할 때는 리스트 업데이트 해줄 것
        _updateBukkungList(updatedBukkungList);
      }
    }
  }

  UploadTask uploadFile(Uint8List image, String location, String filename) {
    var ref = FirebaseStorage.instance.ref().child(location).child(filename);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );
    return ref.putData(image, metadata);
  }

  void _submitBukkungList(
      BukkungListModel bukkungListData, String listId, bool isSelected) async {
    await BukkungListRepository.setGroupBukkungList(bukkungListData, listId);

    //공개되었을 경우
    if (isPublic.value == true && isSelected == false) {
      print('추천 리스트 공개 업로드(upl cont)');
      var uuid = Uuid();
      String imageId = uuid.v4();
      var filename = '$imageId.jpg';
      var task =
          uploadFile(listImage!, 'suggestion_bukkunglist', '${filename}');

      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedBukkungList = bukkungList!.copyWith(
            listId: listId,
            category: listCategory.value,
            title: titleController.text,
            content: contentController.text,
            location: locationController.text,
            imgUrl: downloadUrl,
            imgId: imageId,
            date: listDateTime.value,
          );
          await BukkungListRepository.setSuggestionBukkungList(
              updatedBukkungList, listId);
        }
      });
    }
  }

  void _submitNoImgBukkungList(
      BukkungListModel bukkungListData, String listId, bool isSelected) async {
    await BukkungListRepository.setGroupBukkungList(bukkungListData, listId);

    //공개되었을 경우
    if (isPublic.value == true && isSelected == false) {
      await BukkungListRepository.setSuggestionBukkungList(
          bukkungListData, listId);
    }
  }

  void _updateBukkungList(BukkungListModel bukkungListModel) async {
    await BukkungListRepository.updateGroupBukkungList(bukkungListModel);
  }
}
