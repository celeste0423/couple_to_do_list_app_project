import 'dart:typed_data';

import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/helper/ad_helper.dart';
import 'package:couple_to_do_list_app/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadBukkungListController extends GetxController {
  static UploadBukkungListController get to => Get.find();

  BukkungListModel? selectedBukkungListModel = Get.arguments[0];
  late bool isSuggestion = Get.arguments[1];

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

  late Ticker _ticker;
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();
  ScrollController contentScrollController = ScrollController();

  Uint8List? listImage;

  Rx<bool> isImage = false.obs;
  Rx<bool> isSelectedImage = false.obs;
  Rx<bool> isAutoImage = true.obs;

  Rx<bool> isPublic = true.obs;
  BukkungListModel? bukkungList;
  String? newListId;

  Rx<bool> isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    AdHelper.createInterstitialAd();

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

    // contentFocusNode.addListener(() {
    //   scrollToContent();
    // });
    // contentScrollController.addListener(scrollToContent);
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
        // print('사진 없음(upl cont) ${selectedBukkungListModel!.imgUrl}');
        isSelectedImage(false);
      } else {
        // print('사진 있음(upl cont');
        isSelectedImage(true);
      }
    }
  }

  void _checkCompleted() {
    if (titleController.text.isNotEmpty &&
        listCategory.value!.isNotEmpty &&
        locationController.text.isNotEmpty &&
        // listDateTime.value != null &&
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

  void scrollToContent() async {
    await Future.delayed(Duration(milliseconds: 400));
    //  print('스크롤 시작${contentFocusNode.hasFocus}');
    if (contentFocusNode.hasFocus) {
      // print('스크롤 가능 ${contentScrollController.hasClients}');
      if (contentScrollController.hasClients) {
        //  print('스크롤 중');
        contentScrollController.animateTo(
          contentScrollController.position.maxScrollExtent - 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  // void pickImageFromGallery(BuildContext context) async {
  //   // To set maxheight of images that you want in your app
  //   final image = await Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => ImagePickerPage()));
  //   if (image == null) {
  //     print('선택한 이미지가 없습니다(upl cont)');
  //     isImage(false);
  //     return;
  //   }
  //   isImage(true);
  //   listImage = image;
  // }

  void pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        // To set quality of images
        maxHeight: 500,
        // To set maxheight of images that you want in your app
        maxWidth: 500,
      );

      if (pickedFile == null) {
        // print('No image selected');
        isImage(false);
        return;
      }

      isImage(true);

      // Convert PickedFile to Uint8List
      final imageBytes = await pickedFile.readAsBytes();
      listImage = Uint8List.fromList(imageBytes);
    } catch (e) {
      //print('Error picking image: $e');
      isImage(false);
    }
  }

  Future<void> uploadBukkungList() async {
    // print('날짜는 현재 이거야 ${selectedBukkungListModel!.date}');
    FocusManager.instance.primaryFocus?.unfocus();
    var uuid = Uuid();
    String listId = uuid.v1();
    newListId = listId;
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';

    if (selectedBukkungListModel == null && listImage != null) {
      //선택 안함, 사진 있음
      var task = uploadFile(listImage!, 'group_bukkunglist',
          '${AuthController.to.user.value.groupId}/$filename');

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
      String? autoImageUrl = await getOnlineImage(titleController.text);
      if (isAutoImage.value == true && autoImageUrl != null) {
        //추천 이미지 있을 경우
        var updatedBukkungList = bukkungList!.copyWith(
          listId: listId,
          category: listCategory.value,
          title: titleController.text,
          content: contentController.text,
          location: locationController.text,
          imgUrl: autoImageUrl,
          likeCount: 0,
          date: listDateTime.value,
        );
        _submitNoImgBukkungList(updatedBukkungList, listId, false);
      } else {
        //추천 이미지 없을 경우
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
      }
    } else if (selectedBukkungListModel != null &&
        isSelectedImage.value == true &&
        listImage == null) {
      // 선택함, 사진 있음(웹사진)
      String? downloadUrl;
      if (isSuggestion) {
        //수정중 => 이미지 주소 그대로 들고옴
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
        Uint8List? sourceData = await sourceRef.getData();
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
      //print('날짜 이거라구${updatedBukkungList.date}');
      if (isSuggestion) {
        _submitBukkungList(updatedBukkungList, listId, true);
      } else {
        //수정할 때는 리스트 업데이트 해줄 것
        _updateBukkungList(updatedBukkungList);
      }
    } else if (selectedBukkungListModel != null && listImage != null) {
      //선택함, 사진 있음(로컬사진)
      //print('선택함, 사진있음(로컬사진)');
      if (!isSuggestion) {
        //수정중 => 기존 사진 삭제, 새 사진 업로드
        //  print('기존 사진 삭제');
        BukkungListRepository.deleteImage(selectedBukkungListModel!.imgUrl!);
      }
      var task = uploadFile(listImage!, 'group_bukkunglist',
          '${AuthController.to.user.value.groupId}/$filename');
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
      // print('선택함, 사진없음');
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
    AdHelper.showInterstitialAd();
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
    await BukkungListRepository.setGroupBukkungList(
        bukkungListData, listId, null);

    //공개되었을 경우
    if (isPublic.value == true && isSelected == false) {
      // print('추천 리스트 공개 업로드(upl cont)');
      var uuid = Uuid();
      String imageId = uuid.v4();
      var filename = '$imageId.jpg';
      var task = uploadFile(listImage!, 'suggestion_bukkunglist', filename);

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
    BukkungListModel bukkungListData,
    String listId,
    bool isSelected,
  ) async {
    await BukkungListRepository.setGroupBukkungList(
        bukkungListData, listId, null);

    //공개되었을 경우
    if (isPublic.value == true && isSelected == false) {
      await BukkungListRepository.setSuggestionBukkungList(
          bukkungListData, listId);
    }
  }

  Future<String?> getOnlineImage(String searchWords) async {
    final response = await http.get(
      Uri.parse(
          "https://api.pexels.com/v1/search?query=${searchWords}&locale=ko-KR&per_page=1"),
      headers: {
        'Authorization':
            'vj40CWvim48eP6I6ymW21oHCbU50DVS4Dyj8y4b4GZVIKaWaT9EisapB'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      // 안전하게 null 체크를 수행하고 photos가 없으면 null을 반환
      List<dynamic>? photos = data['photos'];
      if (photos == null || photos.isEmpty) {
        return null;
      }
      Map<String, dynamic>? firstPhoto = photos[0];
      if (firstPhoto == null) {
        return null;
      }
      String? originalImageUrl = firstPhoto['src']['original'];
      return originalImageUrl;
    } else {
      // 오류가 발생한 경우에도 null 반환
      print('추천 사진 없음 오류 (upl buk cont)');
      return null;
    }
  }

  void _updateBukkungList(BukkungListModel bukkungListModel) async {
    await BukkungListRepository.updateGroupBukkungList(bukkungListModel);
  }

  Future<void> sendCompletedMessageToBuddy() async {
    final buddyUid = AuthController.to.user.value.gender == 'male'
        ? AuthController.to.group.value.femaleUid
        : AuthController.to.group.value.maleUid;
    print('짝꿍 uid ${buddyUid}');
    final userTokenData = await FCMController().getDeviceTokenByUid(buddyUid!);
    if (userTokenData != null) {
      print('유저 토큰 존재');
      if (selectedBukkungListModel != null) {
        //추천 리스트에서 가져온 경우
        FCMController().sendMessageController(
          userToken: userTokenData.deviceToken!,
          title: "${AuthController.to.user.value.nickname}님이 새 버꿍리스트를 추가했어요!",
          body: selectedBukkungListModel!.title!,
          dataType: 'bukkunglist',
          dataContent: selectedBukkungListModel!.listId,
          groupId: AuthController.to.group.value.uid,
        );
      } else {
        //리스트를 완전히 새로 만든 경우
        FCMController().sendMessageController(
          userToken: userTokenData.deviceToken!,
          title: "${AuthController.to.user.value.nickname}님이 새 버꿍리스트를 추가했어요!",
          body: titleController.text,
          dataType: 'bukkunglist',
          dataContent: newListId,
          groupId: AuthController.to.group.value.uid,
        );
      }
    }
  }
}
