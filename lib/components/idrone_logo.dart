import 'dart:math';
import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class IDroneLogoWidget extends StatelessWidget {
  final double size;
  final Color? greenColor;
  final Color? backgroundColor;
  final bool showBackground;

  const IDroneLogoWidget({
    super.key,
    this.size = 80,
    this.greenColor,
    this.backgroundColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = isDark ? const Color(0xFF061E14) : const Color(0xFFE8F4EC);
    final defaultIcon = isDark ? const Color(0xFF00D215) : AppColors.deepForest;

    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: backgroundColor ?? defaultBg,
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            )
          : null,
      padding: EdgeInsets.all(size * 0.16),
      child: CustomPaint(
        painter: _DronePainter(color: greenColor ?? defaultIcon),
      ),
    );
  }
}

class _DronePainter extends CustomPainter {
  final Color color;

  _DronePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.12;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Center hollow square body
    final sqSize = size.width * 0.22;
    final sqRect = Rect.fromCenter(center: Offset(cx, cy), width: sqSize, height: sqSize);
    final sqRRect = RRect.fromRectAndRadius(sqRect, const Radius.circular(3));
    canvas.drawRRect(sqRRect, strokePaint);

    // Inner square dot / hole
    final innerSqSize = size.width * 0.05;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy), width: innerSqSize, height: innerSqSize),
      fillPaint,
    );

    // 4 Diagonal arms & 4 Inward C-ring propeller guards
    final armLen = size.width * 0.27;
    final propRadius = size.width * 0.17;
    final angles = [-pi / 4, pi / 4, 3 * pi / 4, -3 * pi / 4];

    for (final angle in angles) {
      final armX = cx + armLen * cos(angle);
      final armY = cy + armLen * sin(angle);

      // Diagonal arm line from center square corner to propeller center
      canvas.drawLine(Offset(cx, cy), Offset(armX, armY), strokePaint);

      // Inward facing C-ring arc:
      final gapCenter = angle + pi;
      final startAngle = gapCenter + pi / 4;
      const sweepAngle = 1.5 * pi;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(armX, armY), radius: propRadius),
        startAngle,
        sweepAngle,
        false,
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
