import 'package:flutter/material.dart';

class BasicContainer extends StatelessWidget {
  final Widget child;
  const BasicContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}
