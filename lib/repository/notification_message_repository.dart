import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationMessageRepository {
  NotificationMessageRepository();

  Future reqIOSPermission(FirebaseMessaging fbMsg) async {
    NotificationSettings settings = await fbMsg.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getFcmToken() async {
    //토큰 발급
    var fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BFxYuSIahcU4oMs_Ang7Gxcp6d78v1kuSq46RojpJW23rrNsjdhxbvMbTBANmJy7juyngTyp7UMhIhN_vp8YRTw");
    return fcmToken;
  }

  Future<void> fbMsgBackgroundHandler(RemoteMessage message) async {
    //백그라운드 메시지 핸들러
    print("[FCM - Background] MESSAGE : ${message.messageId}");
  }
}
