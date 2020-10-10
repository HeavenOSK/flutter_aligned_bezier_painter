import 'package:flutter/material.dart';

class GuidePainter extends CustomPainter {
  GuidePainter({
    @required this.startAlignment,
    @required this.firstControlAlignment,
    this.secondControlAlignment,
    @required this.endAlignment,
  })  : assert(startAlignment != null),
        assert(firstControlAlignment != null),
        assert(endAlignment != null);

  final Alignment startAlignment;
  final Alignment firstControlAlignment;
  final Alignment secondControlAlignment;
  final Alignment endAlignment;

  @override
  void paint(Canvas canvas, Size size) {
    final startPoint = startAlignment.alongSize(size);
    final firstPoint = firstControlAlignment.alongSize(size);
    final endPoint = endAlignment.alongSize(size);

    final guidPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final guidePath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(
        firstPoint.dx,
        firstPoint.dy,
      );

    if (secondControlAlignment != null) {
      final secondPoint = secondControlAlignment.alongSize(size);
      guidePath.lineTo(
        secondPoint.dx,
        secondPoint.dy,
      );
    }
    guidePath.lineTo(
      endPoint.dx,
      endPoint.dy,
    );
    canvas.drawPath(guidePath, guidPaint);
  }

  @override
  bool shouldRepaint(GuidePainter oldDelegate) => true;
}
