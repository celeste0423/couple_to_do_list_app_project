import 'dart:convert';
import 'dart:io';

import 'package:couple_to_do_list_app/src/features/read_bukkung_list/pages/read_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/src/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/src/features/read_suggestion_list/pages/read_suggestion_list_page.dart';
import 'package:couple_to_do_list_app/src/helper/background_message/repository/fcm_repository.dart';
import 'package:couple_to_do_list_app/src/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/src/models/device_token_model.dart';
import 'package:couple_to_do_list_app/src/models/diary_model.dart';
import 'package:couple_to_do_list_app/src/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/src/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/src/repository/suggestion_list_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FCMController {
  final String _serverKey =
      "AAAAXAfR3tg:APA91bGcuXLBYeTnasJULQUnpVTGbFipzfZ1badsIxXgMymNNwRPffH3XDPytHqO8mvpfn-fBuPeLiyiy28YjOWgZ_HBqQE4rQmDZVu7eHlYTJHh7z5dWu06zyC4-P_0qm4h4hQegGwi";

  Future<String?> getMyDeviceToken() async {
    // ios
    String? token;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }
    // android
    else {
      token = await FirebaseMessaging.instance.getToken();
    }
    return token;
  }

  Future<DeviceTokenModel?> getDeviceTokenByUid(String uid) async {
    final token = await FCMRepository().getDeviceTokenByUid(uid);
    return token;
  }

  Future<void> uploadDeviceToken(
    String? deviceToken,
    String? uid,
    String platform,
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
        platform: platform,
        createdAt: DateTime.now(),
      );

      FCMRepository().setDeviceToken(deviceTokenData);
    } else {
      DeviceTokenModel deviceTokenData = DeviceTokenModel(
        tid: isDeviceToken.tid,
        uid: uid,
        deviceToken: deviceToken,
        platform: platform,
        createdAt: DateTime.now(),
      );

      FCMRepository().updateDeviceToken(deviceTokenData);
    }
  }

  Future<void> sendMessageController({
    required String userToken,
    required String platform,
    required String title,
    required String body,
    String? dataType,
    String? dataContent,
    String? groupId,
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

    if (platform == 'ios') {
      userToken = await convertApnsToFCMToken(userToken);
    }

    try {
      print('메시지 보내기 시작');
      response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey'
        },
        // body: json.encode({
        //   "message": {
        //     "to": userToken,
        //     // "topic": "user_uid",
        //     "content_available": true,
        //     'ttl': '60s',
        //     "notification": {
        //       "title": title,
        //       "body": body,
        //     },
        //     "data": {
        //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
        //       "data_type": dataType,
        //       "data_content": dataContent,
        //     },
        //     // "android": {
        //     //   "notification": {
        //     //     "click_action": "Android Click Action",
        //     //   }
        //     // },
        //     "apns": {
        //       "payload": {
        //         "aps": {
        //           "category": "Message Category",
        //           "content-available": 1,
        //           "sound": "default",
        //         }
        //       }
        //     }
        //   }
        // }),
        body: jsonEncode({
          'notification': {'title': title, 'body': body, 'sound': 'false'},
          'ttl': '60s',
          "content_available": true,
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "data_type": dataType,
            "data_content": dataContent,
          },
          // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
          'to': userToken,
          "apns": {
            "payload": {
              "aps": {
                "category": "Message Category",
                "content-available": 1,
                "sound": "default",
                "alert": {
                  "title": title,
                  "body": dataContent,
                }
              }
            }
          },
          // 'registration_ids': tokenList
        }),
      );
      print('HTTP Response Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');
    } catch (e) {
      print('error $e');
    }
  }

  //HTTP v1 방식의 보안 전송 (권장)
  Future<String?> sendMessageV1Controller({
    required String userToken,
    required String title,
    required String body,
    String? dataType,
    String? dataContent,
  }) async {
    try {
      String accessToken =
          'ya29.a0AfB_byAP-E3RXufxkEVvpcF-yGaqvGlhXSOauAhFjRf68W9a3G5ti1Lv5V85gsIx7Au8g9K9vJpXgwmHZWWezjeTYdDwWSQu9kucWQ9U7tLNz0Mlf-fre2ay1D-h6OYUbcZCaPRcipzbIdd7axa-MvWQmOTmpabtYSR5aCgYKAWoSARASFQHGX2MisVLzRBiFfYdrlNiX7keSKg0171';

      http.Response response = await http.post(
        Uri.parse(
          "https://fcm.googleapis.com/v1/projects/bukkunglist/messages:send",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "message": {
            "token": userToken,
            // "topic": "user_uid",

            "notification": {
              "title": title,
              "body": body,
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "data_type": dataType,
              "data_content": dataContent,
            },
            // "android": {
            //   "notification": {
            //     "click_action": "Android Click Action",
            //   }
            // },
            "apns": {
              "payload": {
                "aps": {
                  "category": "Message Category",
                  "content-available": 1,
                  "sound": "default",
                }
              }
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        print('알림 보내기 완료 v1 (fcm cont)');
        return null;
      } else {
        print('알림 보내기 실패 ${response.statusCode}');
        print('알림 보내기 실패 ${response.headers}');
        return "Faliure";
      }
    } on HttpException catch (error) {
      print(error);
      return error.message;
    }
  }

  Future<String> convertApnsToFCMToken(String apnsToken) async {
    const String yourServerKey =
        'AAAAXAfR3tg:APA91bGcuXLBYeTnasJULQUnpVTGbFipzfZ1badsIxXgMymNNwRPffH3XDPytHqO8mvpfn-fBuPeLiyiy28YjOWgZ_HBqQE4rQmDZVu7eHlYTJHh7z5dWu06zyC4-P_0qm4h4hQegGwi'; // FCM Console에서 얻은 서버 키로 대체
    const String url = 'https://iid.googleapis.com/iid/v1:batchImport';
    final Map<String, dynamic> requestBody = {
      "application": "com.example.coupleToDoListApp",
      "sandbox": true,
      "apns_tokens": [apnsToken]
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$yourServerKey'
    };
    final http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(requestBody));
    print('변환중 ${response.body}');
    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);
      final String registrationToken =
          responseData['results'][0]['registration_token'];
      return registrationToken;
    } else {
      throw Exception(
          'Failed to convert APNS to FCM token. ${response.statusCode}');
    }
  }

  //알림 수신 관련
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // print('메시지 받아보는중');
    if (initialMessage != null) {
      _handleMessage(initialMessage);
      // print('메시지 받아왔어용(auth cont) ${initialMessage.data['data_content']}');
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    String dataType = message.data['data_type'];
    Future.delayed(Duration(milliseconds: 500), () async {
      switch (dataType) {
        case 'diary':
          {
            DiaryModel? receivedDiary =
                await DiaryRepository().getDiary(message.data['data_content']);
            Get.to(() => ReadDiaryPage(), arguments: receivedDiary);
            break;
          }
        case 'bukkunglist':
          {
            BukkungListModel? receivedBukkunglist =
                await BukkungListRepository()
                    .getBukkungList(message.data['data_content']);
            print('data: ${message.data['data_content']}');
            Get.to(() => ReadBukkungListPage(), arguments: receivedBukkunglist);
            break;
          }
        case 'comment':
          {
            BukkungListModel? receivedBukkunglist =
                await SuggestionListRepository()
                    .getSuggestionListById(message.data['data_content']);
            Get.to(() => ReadSuggestionListPage(),
                arguments: receivedBukkunglist);
            break;
          }
        default:
          break;
      }
    });
  }
}
