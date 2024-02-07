import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/notification_model.dart';

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
      rethrow;
    }
  }

  Future<List<NotificationModel>> getAllNotifications(String uid) async {
    try {
      // 해당 사용자의 notification 서브컬렉션에 대한 쿼리
      print('알림 받아오기 시작');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('notification')
              .orderBy('created_at')
              .get();
      List<NotificationModel> notifications = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              NotificationModel.fromJson(doc.data()!))
          .toList();
      print('알림 받아왔음 ${notifications.length}');
      return notifications;
    } catch (e) {
      // 오류 처리
      print('getAllNotifications 오류: $e');
      return []; // 오류가 발생하면 빈 리스트를 반환
    }
  }

  Future<void> updateIsChecked(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.to.user.value.uid)
          .collection('notification')
          .doc(notificationId)
          .update({
        'is_checked': true,
      });
    } catch (e) {
      // 오류 처리
      print('updateIsChecked 오류: $e');
      // throw e; // 오류를 다시 던지거나 처리 방법에 따라 적절히 처리
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
              .where('is_checked', isEqualTo: false)
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
