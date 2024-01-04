import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/comment_model.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';

class CommentRepository {
  CommentRepository();

  Future<void> setComment(
    String suggestionListId,
    CommentModel commentData,
  ) async {
    print('업로드 중');
    await FirebaseFirestore.instance
        .collection('bukkungLists')
        .doc(suggestionListId)
        .collection('comments')
        .doc(commentData.commentId)
        .set(commentData.toJson());
  }

  Future<void> deleteComment(
    String suggestionListId,
    String commentId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('bukkungLists')
          .doc(suggestionListId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print("notification 문서 삭제 오류: $e");
      rethrow;
    }
  }

  Stream<List<CommentModel>> getComments(String suggestionListId) {
    return FirebaseFirestore.instance
        .collection('bukkungLists')
        .doc(suggestionListId)
        .collection('comments')
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((event) {
      List<CommentModel> comments = [];
      for (var comment in event.docs) {
        comments.add(CommentModel.fromJson(comment.data()));
      }
      print('comment ${comments.length}');
      return comments;
    });
  }
}
