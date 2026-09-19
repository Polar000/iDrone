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
    this.greenColor = const Color(0xFF00C814),
    this.backgroundColor = const Color(0xFF0A1C12),
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
            )
          : null,
      padding: EdgeInsets.all(size * 0.15),
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
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final armLen = size.width * 0.26;

    // Center square body
    final sqSize = size.width * 0.20;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy), width: sqSize, height: sqSize),
      strokePaint..style = PaintingStyle.stroke,
    );

    // Diagonal arms & Propeller rings
    final angles = [pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4];
    final propRadius = size.width * 0.18;

    for (final angle in angles) {
      final armX = cx + armLen * cos(angle);
      final armY = cy + armLen * sin(angle);

      // Draw diagonal arm
      canvas.drawLine(Offset(cx, cy), Offset(armX, armY), strokePaint);

      // Draw propeller arc/ring
      final propCenterX = cx + (armLen + propRadius * 0.5) * cos(angle);
      final propCenterY = cy + (armLen + propRadius * 0.5) * sin(angle);

      canvas.drawArc(
        Rect.fromCircle(center: Offset(propCenterX, propCenterY), radius: propRadius),
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
