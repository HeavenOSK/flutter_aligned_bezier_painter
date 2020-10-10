import 'package:flutter/material.dart';

/// A painter to draw bezier curve with [Alignment]s.
///
/// [secondControlAlignment] is optional parameter. You have to define
/// it if you want to draw cubic bezier curve.
class AlignedBezierPainter extends CustomPainter {
  AlignedBezierPainter({
    @required this.strokeColor,
    @required this.strokeWidth,
    @required this.startAlignment,
    @required this.firstControlAlignment,
    this.secondControlAlignment,
    @required this.endAlignment,
  })  : assert(strokeColor != null),
        assert(strokeWidth != null && strokeWidth > 0),
        assert(startAlignment != null),
        assert(firstControlAlignment != null),
        assert(endAlignment != null);

  /// A color of stroke for bezier curve.
  final Color strokeColor;

  /// A width of stroke for bezier curve.
  final double strokeWidth;

  /// An alignment of Bézier curve starting point.
  final Alignment startAlignment;

  /// An alignment of the first point to control Bézier curve.
  final Alignment firstControlAlignment;

  /// An alignment of the second point to control Bézier curve.
  final Alignment secondControlAlignment;

  /// An alignment of Bézier curve end point.
  final Alignment endAlignment;

  bool get _isQuadratic => secondControlAlignment == null;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = strokeColor
      ..strokeWidth = strokeWidth;

    final startPoint = startAlignment.alongSize(size);
    final firstControlPoint = firstControlAlignment.alongSize(size);
    final endPoint = endAlignment.alongSize(size);

    final path = Path()..moveTo(startPoint.dx, startPoint.dy);

    if (_isQuadratic) {
      path.quadraticBezierTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    } else {
      final secondControlPoint = secondControlAlignment.alongSize(size);
      path.cubicTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        secondControlPoint.dx,
        secondControlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AlignedBezierPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth &&
      oldDelegate.strokeColor != strokeColor &&
      oldDelegate.startAlignment != startAlignment &&
      oldDelegate.firstControlAlignment != firstControlAlignment &&
      oldDelegate.secondControlAlignment != secondControlAlignment &&
      oldDelegate.endAlignment != endAlignment;
}
