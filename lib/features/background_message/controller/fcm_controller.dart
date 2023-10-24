import 'dart:convert';

import 'package:couple_to_do_list_app/features/background_message/repository/fcm_repository.dart';
import 'package:couple_to_do_list_app/models/device_token_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FCMController {
  final String _serverKey =
      "BFxYuSIahcU4oMs_Ang7Gxcp6d78v1kuSq46RojpJW23rrNsjdhxbvMbTBANmJy7juyngTyp7UMhIhN_vp8YRTw";

  Future<String?> getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<DeviceTokenModel?> getDeviceTokenByUid(String uid) async {
    final token = await FCMRepository().getDeviceTokenByUid(uid);
    return token;
  }

  Future<void> uploadDeviceToken(
    String? deviceToken,
    String? uid,
  ) async {
    DeviceTokenModel? isDeviceToken =
        await FCMRepository().getDeviceTokenByUid(uid!);

    if (isDeviceToken == null) {
      var uuid = Uuid();
      String tid = uuid.v1();

      DeviceTokenModel deviceTokenData = DeviceTokenModel(
        tid: tid,
        uid: uid,
        deviceToken: deviceToken,
        createdAt: DateTime.now(),
      );

      FCMRepository().setDeviceToken(deviceTokenData);
    } else {
      DeviceTokenModel deviceTokenData = DeviceTokenModel(
        tid: isDeviceToken.tid,
        uid: uid,
        deviceToken: deviceToken,
        createdAt: DateTime.now(),
      );

      FCMRepository().updateDeviceToken(deviceTokenData);
    }
  }

  Future<void> sendMessageController({
    required String userToken,
    required String title,
    required String body,
  }) async {
    http.Response response;

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );
    print('메시지 권한 요청');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      print('메시지 보내기 시작');
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            'notification': {'title': title, 'body': body, 'sound': 'false'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": '테스트',
            },
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            'to': userToken
            // 'registration_ids': tokenList
          }));
    } catch (e) {
      print('error $e');
    }
  }
}
