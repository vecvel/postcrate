import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The Postcrate mark, on a 24-unit grid: an orbit ring (r 8.5, stroke 2.5)
/// with a paper plane flying clockwise on it at -45 degrees. Keep in sync with
/// scripts/logo/generate.mjs, which solves the arc end angles used below.
class PcMark extends StatelessWidget {
  const PcMark({super.key, this.size = 26, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Postcrate',
      image: true,
      child: CustomPaint(size: Size.square(size), painter: _MarkPainter(color)),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.color);

  final Color color;

  static const _orbitRadius = 8.5;
  static const _orbitWidth = 2.5;
  static const _arcStartDeg = 1.35;
  static const _arcEndDeg = 254.40;
  static const _planeAngleDeg = -45.0;
  static const _planeScale = 0.78;
  static const _planeStroke = 1.2;

  static final _plane = Path()
    ..moveTo(0, 0)
    ..lineTo(11, 4.5)
    ..lineTo(0, 9)
    ..lineTo(2.6, 4.5)
    ..close();

  static double _rad(double d) => d * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);

    canvas.drawArc(
      Rect.fromCircle(center: const Offset(12, 12), radius: _orbitRadius),
      _rad(_arcStartDeg),
      _rad(_arcEndDeg - _arcStartDeg),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _orbitWidth
        ..strokeCap = StrokeCap.round,
    );

    final a = _rad(_planeAngleDeg);
    canvas.translate(12 + _orbitRadius * math.cos(a), 12 + _orbitRadius * math.sin(a));
    canvas.rotate(_rad(45));
    canvas.scale(_planeScale);
    canvas.translate(-5.5, -4.5);
    canvas.drawPath(_plane, Paint()..color = color);
    canvas.drawPath(
      _plane,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _planeStroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}
