import 'package:flutter/material.dart';

class UnderlinedTextField extends StatelessWidget {
  const UnderlinedTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List x =[for (int i = 0; i < 5; i++) i, 9999];
    print(x);
    return Stack(
      children: [
        for (int i = 0; i < 5; i++)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: 4 + (i + 1) * 28,
              left: 15,
              right: 15,
            ),
            height: 1,
            color: Colors.black,
          ),
        const SizedBox(
          height: 97,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              decoration: InputDecoration(border: InputBorder.none),
              cursorHeight: 22,
              style: TextStyle(
                fontSize: 20.0,
              ),
              keyboardType: TextInputType.multiline,
              expands: true,
              maxLines: null,
            ),
          ),
        ),
      ],
    );
  }
}
