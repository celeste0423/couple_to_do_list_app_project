import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/bukkung_list_page_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/comment_model.dart';
import 'package:couple_to_do_list_app/models/copy_count_model.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';
import 'package:couple_to_do_list_app/repository/comment_repository.dart';
import 'package:couple_to_do_list_app/repository/copy_count_repository.dart';
import 'package:couple_to_do_list_app/repository/list_completed_repository.dart';
import 'package:couple_to_do_list_app/repository/list_suggestion_repository.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
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
    ListSuggestionRepository().addCopyCount(bukkungListModel.listId!);
  }
}
