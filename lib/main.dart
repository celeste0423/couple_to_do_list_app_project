import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/auth/root/root.dart';
import 'package:couple_to_do_list_app/firebase_options.dart';
import 'package:couple_to_do_list_app/theme/base_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리 ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//안드로이드 푸시 알림
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        'high_importance_channel', // id
        'high_importance_notification', // name
        importance: Importance.max,
      ));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  KakaoSdk.init(nativeAppKey: '6343b85d09998d34e9261b1c6e5f4635');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //푸쉬 알림
  initializeNotification();

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
    );
  }
}
