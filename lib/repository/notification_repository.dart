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

  Future<bool> isUncheckedNotification(String uid) async {
    try {
      // 해당 사용자의 notification 서브컬렉션에 대한 쿼리
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('notification')
              .where('isChecked', isEqualTo: false)
              .limit(1) // 하나 이상이 필요하지 않으므로 최대 1개만 가져옴
              .get();

      // 결과에서 문서가 하나라도 있으면 true를 반환
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // 오류 처리
      print('isUncheckedNotification 오류: $e');
      return false; // 오류가 발생하면 false를 반환
    }
  }
}
