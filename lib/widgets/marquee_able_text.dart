import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeAbleText extends StatelessWidget {
  final String text;
  final int maxLength;
  late final TextStyle? style;

  MarqueeAbleText({
    Key? key,
    required this.text,
    required this.maxLength,
    this.style,
  }) : super(key: key);

  double getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    style ??= Theme.of(context).textTheme.bodyMedium;
    if (text.length > maxLength) {
      return SizedBox(
        height: style!.fontSize,
        width: getTextWidth(text, style!) / text.length * maxLength,
        child: Marquee(
          text: text,
          style: style,
          velocity: 30,
          startPadding: 10,
          blankSpace: maxLength.toDouble() + 20,
          pauseAfterRound: Duration(seconds: 1),
          scrollAxis: Axis.horizontal,
        ),
      );
    } else {
      return Text(
        text,
        style: style,
      );
    }
  }
}
