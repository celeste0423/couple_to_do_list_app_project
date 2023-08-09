import 'package:flutter/material.dart';
class basicContainer extends StatelessWidget {
  final Widget child;
   const basicContainer({Key? key, required this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: child,
    );
  }
}