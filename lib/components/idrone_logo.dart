import 'dart:math';
import 'package:flutter/material.dart';

class IDroneLogoWidget extends StatelessWidget {
  final double size;
  final Color greenColor;
  final Color backgroundColor;
  final bool showBackground;

  const IDroneLogoWidget({
    super.key,
    this.size = 80,
    this.greenColor = const Color(0xFF00D819),
    this.backgroundColor = const Color(0xFF061A12),
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            )
          : null,
      padding: EdgeInsets.all(size * 0.16),
      child: CustomPaint(
        painter: _DronePainter(color: greenColor),
      ),
    );
  }
}

class _DronePainter extends CustomPainter {
  final Color color;

  _DronePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final armLen = size.width * 0.25;

    // Center hollow square body
    final sqSize = size.width * 0.22;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy), width: sqSize, height: sqSize),
      strokePaint..style = PaintingStyle.stroke,
    );

    // 4 Diagonal arms & 4 Outer C-propeller guards
    final angles = [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4];
    final propRadius = size.width * 0.18;

    for (final angle in angles) {
      final armX = cx + armLen * cos(angle);
      final armY = cy + armLen * sin(angle);

      // Draw thick diagonal arm extending from center square
      canvas.drawLine(Offset(cx, cy), Offset(armX, armY), strokePaint);

      // Draw C-ring propeller guard centered at arm tip
      canvas.drawArc(
        Rect.fromCircle(center: Offset(armX, armY), radius: propRadius),
        angle - pi * 0.75,
        pi * 1.5,
        false,
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
