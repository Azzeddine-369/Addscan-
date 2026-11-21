import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AddiScanLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool isDark;

  const AddiScanLogo({
    super.key,
    this.size = 38,
    this.showTagline = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Custom painted leaf + magnifying glass icon
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.12),
          child: CustomPaint(
            painter: _LogoLeafMagnifierPainter(),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AddiScan',
              style: TextStyle(
                fontSize: size * 0.52,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0C5D54),
                letterSpacing: -0.3,
                height: 1.05,
              ),
            ),
            if (showTagline)
              Text(
                'Know what you eat',
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                  height: 1.15,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LogoLeafMagnifierPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw Green Leaf
    final leafPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    leafPath.moveTo(w * 0.15, h * 0.5);
    leafPath.quadraticBezierTo(w * 0.2, h * 0.05, w * 0.65, h * 0.1);
    leafPath.quadraticBezierTo(w * 0.5, h * 0.55, w * 0.15, h * 0.5);
    leafPath.close();
    canvas.drawPath(leafPath, leafPaint);

    // Leaf center vein
    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(w * 0.2, h * 0.45), Offset(w * 0.55, h * 0.18), veinPaint);

    // 2. Draw Magnifying Glass (Dark Teal)
    final glassPaint = Paint()
      ..color = const Color(0xFF0F8B7F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.14
      ..strokeCap = StrokeCap.round;

    final glassCenter = Offset(w * 0.55, h * 0.52);
    final glassRadius = w * 0.28;
    canvas.drawCircle(glassCenter, glassRadius, glassPaint);

    // Glass handle
    final handlePaint = Paint()
      ..color = const Color(0xFF0F8B7F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.16
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.35, h * 0.72),
      Offset(w * 0.12, h * 0.95),
      handlePaint,
    );

    // White reflection in lens
    final reflectPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    final arcRect = Rect.fromCircle(center: glassCenter, radius: glassRadius * 0.65);
    canvas.drawArc(arcRect, 3.8, 1.2, false, reflectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
