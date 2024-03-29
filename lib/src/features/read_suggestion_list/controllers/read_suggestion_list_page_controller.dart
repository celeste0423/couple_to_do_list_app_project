import 'package:couple_to_do_list_app/src/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/controller/fcm_controller.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/comment_model.dart';
import 'package:couple_to_do_list_app/src/models/copy_count_model.dart';
import 'package:couple_to_do_list_app/src/models/notification_model.dart';
import 'package:couple_to_do_list_app/src/models/user_model.dart';
import 'package:couple_to_do_list_app/src/repository/comment_repository.dart';
import 'package:couple_to_do_list_app/src/repository/copy_count_repository.dart';
import 'package:couple_to_do_list_app/src/repository/notification_repository.dart';
import 'package:couple_to_do_list_app/src/repository/suggestion_list_repository.dart';
import 'package:couple_to_do_list_app/src/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ReadSuggestionListPageController extends GetxController {
  final BukkungListModel bukkungListModel = Get.arguments;

  Rx<int> userLevel = 0.obs;

  final Rx<String> imgUrl = ''.obs;

  Rx<int?> commentCount = null.obs;
  TextEditingController commentTextController = TextEditingController();
  Rx<bool> isCommentUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    imgUrl(bukkungListModel.imgUrl);
    getUserLevel();
  }

  void getUserLevel() async {
    UserModel? userData =
        await UserRepository.getUserDataByUid(bukkungListModel.userId!);
    final int? expPoint = userData!.expPoint;
    userLevel(expPoint == null ? 0 : (expPoint - expPoint % 100) ~/ 100);
  }

  Stream<List<CommentModel>> getComments() {
    return CommentRepository().getComments(bukkungListModel.listId!);
  }

  Future<void> setComment() async {
    isCommentUploading(true);
    Uuid uuid = Uuid();
    String commentId = uuid.v4();
    CommentModel commentData = CommentModel(
      commentId: commentId,
      uid: AuthController.to.user.value.uid!,
      nickname: AuthController.to.user.value.nickname!,
      comment: commentTextController.text,
      createdAt: DateTime.now(),
    );
    await CommentRepository().setComment(bukkungListModel.listId!, commentData);
    //제작자한테 알림 보내기
    if (bukkungListModel.userId != AuthController.to.user.value.uid) {
      await sendCommentMessageToCreator(commentTextController.text);
    }
    commentTextController.clear();
    isCommentUploading(false);
  }

  Future<void> deleteComment(
    String commentId,
  ) async {
    await CommentRepository()
        .deleteComment(bukkungListModel.listId!, commentId);
  }

  void setCopyCount() {
    var uuid = Uuid();
    String id = uuid.v1();
    CopyCountModel copyCountData = CopyCountModel(
      id: id,
      uid: AuthController.to.user.value.uid,
      listId: bukkungListModel.listId,
      createdAt: DateTime.now(),
    );
    CopyCountRepository().uploadCopyCount(copyCountData);
    SuggestionListRepository().addCopyCount(bukkungListModel.listId!);
  }

  Future<void> sendCommentMessageToCreator(String comment) async {
    final String creatorUid = bukkungListModel.userId!;
    final userTokenData = await FCMController().getDeviceTokenByUid(creatorUid);
    if (userTokenData != null) {
      print('유저 토큰 존재');
      FCMController().sendMessageController(
        userToken: userTokenData.deviceToken!,
        platform: userTokenData.platform,
        title: "내 버꿍리스트에 댓글이 달렸어요",
        body: comment,
        dataType: 'comment',
        dataContent: bukkungListModel.listId,
      );
    }
    //notification page에 업로드
    Uuid uuid = Uuid();
    String notificationId = uuid.v1();
    NotificationModel notificationModel = NotificationModel(
      notificationId: notificationId,
      type: 'comment',
      title: '내 버꿍리스트에 댓글이 달렸어요',
      content: comment,
      contentId: bukkungListModel.listId,
      isChecked: false,
      createdAt: DateTime.now(),
    );
    print('메시지 보냄');
    NotificationRepository().setNotification(creatorUid, notificationModel);
  }
}
