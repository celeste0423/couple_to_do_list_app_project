import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/auth/root/root.dart';
import 'package:couple_to_do_list_app/features/read_bukkung_list/pages/read_bukkung_list_page.dart';
import 'package:couple_to_do_list_app/features/read_diary/pages/read_diary_page.dart';
import 'package:couple_to_do_list_app/firebase_options.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/diary_repository.dart';
import 'package:couple_to_do_list_app/theme/base_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

//백그라운드 메시지
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리 ${message.messageId}");
}

const channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//로컬 알림 보이기(foreground)
Future<void> showFlutterNotification(RemoteMessage message) async{
  String dataType = message.data['data_type'];
  switch (dataType) {
    case 'diary':
      {
        DiaryModel? sendedDiary =
            await DiaryRepository().getDiary(message.data['data_content']);
        Get.to(() => ReadDiaryPage(), arguments: sendedDiary);
        break;
      }
    case 'bukkunglist':
      {
        BukkungListModel? sendedBukkungList = await BukkungListRepository(
                groupModel: AuthController.to.group.value)
            .getBukkungList(message.data['data_content']);
        Get.to(() => ReadBukkungListPage(), arguments: sendedBukkungList);
        break;
      }
    default:
      break;
  }

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    // 웹이 아니면서 안드로이드이고, 알림이 있는경우
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

void initializeNotification() async {
  //foreground 수신 처리
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  //background 수신 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//안드로이드 푸시 알림
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  //IOS foreground 권한 체크
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // IOS background 권한 체킹 , 요청
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}
// 모든 문서에 대해 필드를 추가하고 싶을 경우 사용
// Future<void> addCopyCountFieldToAllDocuments() async {
//   final CollectionReference bukkungListsCollection =
//       FirebaseFirestore.instance.collection('bukkungLists');
//
//   // 모든 문서를 가져오기
//   final QuerySnapshot querySnapshot = await bukkungListsCollection.get();
//
//   // 각 문서에 copyCount 필드 추가 및 초기값 0 할당
//   for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//     final documentReference = bukkungListsCollection.doc(documentSnapshot.id);
//     await documentReference.set({'copyCount': 0}, SetOptions(merge: true));
//   }
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//파이어베이스 설정
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //푸쉬 알림
  initializeNotification();
  //스플래시 이미지
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //카카오 sdk실행
  KakaoSdk.init(nativeAppKey: '6343b85d09998d34e9261b1c6e5f4635');
  //화면 회전 불가
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
    SystemChrome.setSystemUIOverlayStyle(
      //상단바 테마
      SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
    );
  });

  // addCopyCountFieldToAllDocuments().then((_) {
  //   print('copyCount 필드를 모든 문서에 추가 및 초기화했습니다.');
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); //앱 로딩 후 제거해주는 걸로 수정할 것
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
      ],
      initialBinding: InitBinding(),
      title: 'BukkungList',
      theme: baseTheme(),
      home: Root(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
