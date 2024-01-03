import 'dart:convert';
import 'dart:typed_data';

import 'package:couple_to_do_list_app/constants/enum.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/location_auto_complete_response.dart';
import 'package:couple_to_do_list_app/features/upload_bukkung_list/utils/location_network_util.dart';
import 'package:couple_to_do_list_app/helper/ad_helper.dart';
import 'package:couple_to_do_list_app/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:couple_to_do_list_app/repository/notification_repository.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadBukkungListController extends GetxController {
  static UploadBukkungListController get to => Get.find();

  BukkungListModel? selectedBukkungListModel = Get.arguments[0];
  late bool isSuggestion = Get.arguments[1];

  Rx<bool> isCompleted = false.obs;

  TextEditingController titleController = TextEditingController();
  late FocusNode titleFocusNode;
  bool isTitleFocused = false;
  bool isTitleTextEmpty = true;
  List<String> _searchWord = [];
  Rx<bool> isSearchResultLoading = false.obs;
  List<BukkungListModel>? searchBukkungLists = null;

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
  FocusNode contentFocusNode = FocusNode();
  ScrollController contentScrollController = ScrollController();

  Uint8List? listImage;

  // Rx<bool> isImage = false.obs;
  // Rx<bool> isSelectedImage = false.obs;
  Rx<ImageType> imageType = ImageType.baseImage.obs;
  String? autoImageUrl = null;
  Rx<bool> isAutoImage = true.obs;

  Rx<bool> isPublic = true.obs;
  String? newListId;

  Rx<bool> isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    AdHelper.createInterstitialAd();

    _checkIsBukkungListSelected();
    _checkCompleted();
    titleController.addListener(() {
      _checkCompleted;
      _onTitleChanged();
    });
    titleFocusNode = FocusNode();
    titleFocusNode.addListener(_onTitleFocused);
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
        //사진이 기본 이미지
        print('기본 이미지');
        imageType(ImageType.baseImage);
      } else if (selectedBukkungListModel!.imgUrl!
          .startsWith("https://firebasestorage")) {
        //사진이 스토리지 이미지
        print('스토리지 이미지');
        imageType(ImageType.storageOnlineImage);
      } else {
        //사진이 자동 추천 이미지
        print('자동 추천 이미지');
        imageType(ImageType.autoImage);
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

  void _onTitleFocused() {
    isTitleFocused = titleFocusNode.hasFocus;
    update(['uploadPageSearchResult'], true);
  }

  void _onTitleChanged() async {
    _searchWord = titleController.text.split(' ');
    isTitleTextEmpty = titleController.text.isEmpty;

    isSearchResultLoading(true);
    if (!titleController.text.isEmpty) {
      searchBukkungLists = await ListSuggestionRepository()
          .getSearchedBukkungListAsFuture(_searchWord);
    }
    isSearchResultLoading(false);
    // print(searchBukkungLists!.length);
    update(['uploadPageSearchResult'], true);
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

  // void scrollToContent() async {
  //   await Future.delayed(Duration(milliseconds: 400));
  //   //  print('스크롤 시작${contentFocusNode.hasFocus}');
  //   if (contentFocusNode.hasFocus) {
  //     // print('스크롤 가능 ${contentScrollController.hasClients}');
  //     if (contentScrollController.hasClients) {
  //       //  print('스크롤 중');
  //       contentScrollController.animateTo(
  //         contentScrollController.position.maxScrollExtent - 100,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   }
  // }

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
        // isImage(false);
        imageType(ImageType.baseImage);
        return;
      }
      // isImage(true);
      imageType(ImageType.storageOfflineImage);
      // Convert PickedFile to Uint8List
      final imageBytes = await pickedFile.readAsBytes();
      listImage = Uint8List.fromList(imageBytes);
    } catch (e) {
      print('Error picking image: $e');
      openAlertDialog(title: '사진을 선택하지 못했습니다.');
      // isImage(false);
    }
  }

  Future<void> uploadBukkungList() async {
    if (selectedBukkungListModel == null) {
      //새로 만드는 경우
      print('새로 만들어');
      if (isAutoImage.value == true) {
        autoImageUrl = await getOnlineImage(titleController.text);
        if (autoImageUrl != null) {
          imageType(ImageType.autoImage);
        }
      }
      await _uploadNewBukkungList();
    } else if (isSuggestion) {
      //기존 리스트 불러오는 경우
      print('기존 리스트 복사');
      await _copyBukkungList();
    } else {
      //리스트 수정 시
      print('리스트 수정');
      await _changeBukkungList();
    }
  }

  Future<void> _uploadNewBukkungList() async {
    var uuid = Uuid();
    String listId = uuid.v1();
    newListId = listId;
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';
    var newBukkungList = BukkungListModel(
      listId: listId,
      category: listCategory.value,
      title: titleController.text,
      content: contentController.text,
      location: locationController.text,
      imgUrl: null,
      imgId: null,
      // likeCount: 0,
      viewCount: 0,
      copyCount: 0,
      date: listDateTime.value,
      madeBy: AuthController.to.user.value.nickname,
      userId: AuthController.to.user.value.uid,
      groupId: AuthController.to.user.value.groupId,
      createdAt: DateTime.now(),
      updatedAt: null,
      // likedUsers: null,
    );
    //사진 유무에 따른 케이스 분리
    switch (imageType.value) {
      case ImageType.storageOfflineImage:
        //새 이미지 업로드 후 리스트 업로드
        var task = uploadFile(listImage!, 'group_bukkunglist',
            '${AuthController.to.user.value.groupId}/$filename');
        task.snapshotEvents.listen((event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var newOfflineImageBukkungList = newBukkungList.copyWith(
              imgUrl: downloadUrl,
              imgId: imageId,
            );
            _submitBukkungList(newOfflineImageBukkungList, false, true);
          }
        });
        break;
      case ImageType.autoImage:
        //자동 추천 이미지 있을 경우
        var newAutoImageBukkungList = newBukkungList.copyWith(
          imgUrl: autoImageUrl,
        );
        _submitBukkungList(newAutoImageBukkungList, false, false);
        break;
      case ImageType.baseImage:
        //추천이미지 X, 사진 업로드 X
        var newBaseImageBukkungList = newBukkungList.copyWith(
          imgUrl: Constants.baseImageUrl,
        );
        _submitBukkungList(newBaseImageBukkungList, false, false);
        break;
      default:
        openAlertDialog(title: '오류가 발생했습니다.');
    }
  }

  Future<void> _copyBukkungList() async {
    var uuid = Uuid();
    String listId = uuid.v1();
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';
    var copyBukkungList = BukkungListModel(
      listId: listId,
      category: listCategory.value,
      title: titleController.text,
      content: contentController.text,
      location: locationController.text,
      imgUrl: null,
      imgId: null,
      // likeCount: 0,
      viewCount: selectedBukkungListModel!.viewCount,
      copyCount: selectedBukkungListModel!.copyCount,
      date: listDateTime.value,
      madeBy: AuthController.to.user.value.nickname,
      userId: AuthController.to.user.value.uid,
      groupId: AuthController.to.user.value.groupId,
      createdAt: selectedBukkungListModel!.createdAt,
      updatedAt: DateTime.now(),
      // likedUsers: null,
    );
    //케이스 분리
    switch (imageType.value) {
      case ImageType.storageOnlineImage:
        //직접 올린 이미지를 받아왔을 경우
        print('이미지 옮기기 시작');
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
        String downloadUrl = await destinationRef.getDownloadURL();
        print('이게 옮기는 url ${downloadUrl}');
        var storageUpdatedBukkungList = copyBukkungList.copyWith(
          imgUrl: downloadUrl,
          imgId: imageId,
        );
        _submitBukkungList(storageUpdatedBukkungList, true, true);
        break;
      case ImageType.storageOfflineImage:
        //이미지를 새로 업로드 했을 경우
        print('새 이미지 업로드');
        var task = uploadFile(listImage!, 'group_bukkunglist',
            '${AuthController.to.user.value.groupId}/$filename');
        task.snapshotEvents.listen((event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var copyOfflineImageBukkungList = copyBukkungList.copyWith(
              imgUrl: downloadUrl,
              imgId: imageId,
            );
            _submitBukkungList(copyOfflineImageBukkungList, true, false);
          }
        });
        break;
      case ImageType.baseImage:
      case ImageType.autoImage:
        //이미지 주소 그대로 업로드
        print('그냥 이미지 그대로');
        var copyOnlineImageBukkungList = copyBukkungList.copyWith(
          imgUrl: selectedBukkungListModel!.imgUrl,
        );
        _submitBukkungList(copyOnlineImageBukkungList, true, false);
        break;
      default:
        openAlertDialog(title: '오류가 발생했습니다.');
    }
  }

  Future<void> _changeBukkungList() async {
    var uuid = Uuid();
    String imageId = uuid.v4();
    var filename = '$imageId.jpg';
    var updatedBukkungList = BukkungListModel(
      listId: selectedBukkungListModel!.listId,
      category: listCategory.value,
      title: titleController.text,
      content: contentController.text,
      location: locationController.text,
      imgUrl: selectedBukkungListModel!.imgUrl,
      imgId: selectedBukkungListModel!.imgId,
      // likeCount: 0,
      viewCount: selectedBukkungListModel!.viewCount,
      copyCount: selectedBukkungListModel!.copyCount,
      date: listDateTime.value,
      madeBy: AuthController.to.user.value.nickname,
      userId: AuthController.to.user.value.uid,
      groupId: AuthController.to.user.value.groupId,
      createdAt: selectedBukkungListModel!.createdAt,
      updatedAt: DateTime.now(),
      // likedUsers: null,
    );
    //케이스 분리
    switch (imageType.value) {
      case ImageType.storageOfflineImage:
        //기존 이미지 삭제, 새 이미지 업로드
        BukkungListRepository.deleteImage(selectedBukkungListModel!.imgUrl!);
        var task = uploadFile(listImage!, 'group_bukkunglist',
            '${AuthController.to.user.value.groupId}/$filename');
        task.snapshotEvents.listen((event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var updateOfflineImageBukkungList = updatedBukkungList.copyWith(
              imgUrl: downloadUrl,
              imgId: imageId,
            );
            _updateBukkungList(updateOfflineImageBukkungList);
          } else {
            _updateBukkungList(updatedBukkungList);
          }
        });
        break;
      case ImageType.baseImage:
      case ImageType.autoImage:
      case ImageType.storageOnlineImage:
        _updateBukkungList(updatedBukkungList);
        break;
      default:
        openAlertDialog(title: '오류가 발생했습니다.');
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
    BukkungListModel bukkungListData,
    bool isSelected,
    bool isStorageImage,
  ) async {
    await BukkungListRepository.setGroupBukkungList(
      bukkungListData,
      null,
    );
    //공개되었을 경우
    if (isPublic.value == true && isSelected == false) {
      var uuid = Uuid();
      String suggestionListId = uuid.v1();
      if (isStorageImage) {
        String imageId = uuid.v4();
        var filename = '$imageId.jpg';
        var task = uploadFile(listImage!, 'suggestion_bukkunglist', filename);

        task.snapshotEvents.listen((event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var updatedBukkungList = bukkungListData.copyWith(
              listId: suggestionListId,
              imgUrl: downloadUrl,
              imgId: imageId,
            );
            await BukkungListRepository.setSuggestionBukkungList(
                updatedBukkungList);
          }
        });
      } else {
        var updatedNoImgBukkungList = bukkungListData.copyWith(
          listId: suggestionListId,
        );
        await BukkungListRepository.setSuggestionBukkungList(
            updatedNoImgBukkungList);
      }
    }
  }

  void _updateBukkungList(BukkungListModel bukkungListModel) async {
    await BukkungListRepository.updateGroupBukkungList(bukkungListModel);
  }

  Future<String?> getOnlineImage(String searchWords) async {
    final response = await http.get(
      Uri.parse(
          "https://api.pexels.com/v1/search?query=$searchWords&locale=ko-KR&per_page=1"),
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

  Future<void> sendCompletedMessageToBuddy() async {
    final buddyUid = AuthController.to.user.value.gender == 'male'
        ? AuthController.to.group.value.femaleUid
        : AuthController.to.group.value.maleUid;
    if (isSuggestion) {
      final userTokenData =
          await FCMController().getDeviceTokenByUid(buddyUid!);
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
          );
        } else {
          //리스트를 완전히 새로 만든 경우
          FCMController().sendMessageController(
            userToken: userTokenData.deviceToken!,
            title: "${AuthController.to.user.value.nickname}님이 새 버꿍리스트를 추가했어요!",
            body: titleController.text,
            dataType: 'bukkunglist',
            dataContent: newListId,
          );
        }
      }
    }
    //notification page에 업로드
    Uuid uuid = Uuid();
    String notificationId = uuid.v1();
    NotificationModel notificationModel = NotificationModel(
      notificationId: notificationId,
      type: 'bukkunglist',
      title: '${AuthController.to.user.value.nickname}님이 새 버꿍리스트를 추가했어요!',
      content: '지금 바로 확인해보세요',
      contentId: selectedBukkungListModel == null
          ? newListId
          : selectedBukkungListModel!.listId,
      isChecked: false,
      createdAt: DateTime.now(),
    );
    NotificationRepository().setNotification(buddyUid!, notificationModel);
  }
}
