import 'package:couple_to_do_list_app/features/auth/pages/welcome_page.dart';
import 'package:couple_to_do_list_app/theme/base_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bukkung List',
      theme: baseTheme(),
      home: const WelcomePage(),
    );
  }
}
