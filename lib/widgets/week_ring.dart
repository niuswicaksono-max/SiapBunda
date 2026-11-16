import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 40 titik melingkar = 40 minggu kehamilan. Titik yang terisi = minggu berjalan.
class WeekRingPainter extends CustomPainter {
  const WeekRingPainter({
    required this.filled,
    required this.onColor,
    required this.offColor,
  });

  final int filled;
  final Color onColor;
  final Color offColor;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = size.shortestSide * 0.018;
    final radius = size.shortestSide / 2 - dot * 3;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 40; i++) {
      final angle = -math.pi / 2 + 2 * math.pi * i / 40;
      final offset = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      final isOn = i < filled;
      paint.color = isOn ? onColor : offColor;
      canvas.drawCircle(offset, isOn ? dot * 1.4 : dot, paint);
    }
  }

  @override
  bool shouldRepaint(WeekRingPainter old) =>
      old.filled != filled || old.onColor != onColor || old.offColor != offColor;
}

class WeekRing extends StatelessWidget {
  const WeekRing({
    super.key,
    required this.filled,
    required this.size,
    required this.onColor,
    required this.offColor,
    required this.child,
  });

  final int filled;
  final double size;
  final Color onColor;
  final Color offColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: WeekRingPainter(
          filled: filled,
          onColor: onColor,
          offColor: offColor,
        ),
        child: Center(child: child),
      ),
    );
  }
}
