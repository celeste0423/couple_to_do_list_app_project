import 'package:flutter/material.dart';

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Rect.fromCircle(
      center: offset + Offset(cfg.size!.width / 2, cfg.size!.height / 2 + 37.4),
      radius: radius,
    );
    const double startAngle = -3.141592; // 시작 각도 (반시계 방향)
    const double sweepAngle = 3.141592; // 반원의 호도 (반시계 방향)

    canvas.drawArc(rect, startAngle, sweepAngle, true, _paint);
  }
  // void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
  //   final Offset circleOffset =
  //       offset + Offset(cfg.size!.width / 2, cfg.size!.height / 2 + 37);
  //   // final Offset circleOffset =
  //   //     offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 5);
  //   canvas.drawCircle(circleOffset, radius, _paint);
  // }
}
