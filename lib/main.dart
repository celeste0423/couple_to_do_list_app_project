import 'package:couple_to_do_list_app/binding/init_binding.dart';
import 'package:couple_to_do_list_app/features/auth/root/loading_page.dart';
import 'package:couple_to_do_list_app/features/auth/root/root.dart';
import 'package:couple_to_do_list_app/firebase_options.dart';
import 'package:couple_to_do_list_app/theme/base_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // KakaoSdk.init(nativeAppKey: '6343b85d09998d34e9261b1c6e5f4635');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //화면 회전 불가
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
    SystemChrome.setSystemUIOverlayStyle(
      //상단바 테마
      SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); //앱 로딩 후 제거해주는 걸로 수정할 것
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBinding(),
      title: 'Bukkung List',
      theme: baseTheme(),
      home: LoadingPage(),
    );
  }
}
