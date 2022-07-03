import 'package:flutter/material.dart';

class Rope extends CustomPainter {
  Rope({
    required this.anchor,
    required this.spring,
  });

  final Offset anchor;
  final Offset spring;
  final Paint springPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(anchor, spring, springPaint);
  }

  @override
  bool shouldRepaint(Rope oldDelegate) {
    return anchor != oldDelegate.anchor || spring != oldDelegate.spring;
  }
}
