import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); //앱 로딩 후 제거해주는 걸로 수정할 것
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bukkung List',
      theme: baseTheme(),
      home: WelcomePage(),
      // home: GetX<UserInfoAuthController>(
      //   init: UserInfoAuthController(),
      //   builer: (controller){
      //     FlutterNativeSplash.remove();
      //     return const WelcomPage();
      //   } else {
      //     return const HomePage();
      //  }
      // )

      // onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
