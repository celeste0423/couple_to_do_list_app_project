import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/copy_count_model.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';
import 'package:couple_to_do_list_app/models/user_model.dart';

class NotificationRepository {
  NotificationRepository();

  Future<void> setNotification(
    String uid,
    NotificationModel notificationData,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notification')
        .doc(notificationData.notificationId)
        .set(notificationData.toJson());
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notification')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print("notification 문서 삭제 오류: $e");
      throw e;
    }
  }

  Future<List<CopyCountModel>?> getCopyCountByListId(String listId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('copyCount')
          .where('list_id', isEqualTo: listId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<CopyCountModel> result = querySnapshot.docs
            .map((doc) =>
                CopyCountModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        return result;
      } else {
        return null; // 데이터가 없는 경우 null 반환 또는 빈 리스트로 처리할 수 있습니다.
      }
    } catch (e) {
      print("copyCount 데이터 가져오기 오류: $e");
      return null;
    }
  }
}
