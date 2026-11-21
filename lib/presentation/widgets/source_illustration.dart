import 'dart:math' as math;
import 'package:flutter/material.dart';

class SourceIllustration extends StatelessWidget {
  final String iconType;
  final double size;

  const SourceIllustration({
    super.key,
    required this.iconType,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SourcePainter(iconType: iconType.toLowerCase()),
      ),
    );
  }
}

class _SourcePainter extends CustomPainter {
  final String iconType;

  _SourcePainter({required this.iconType});

  @override
  void paint(Canvas canvas, Size size) {
    switch (iconType) {
      case 'lemon':
        _paintLemon(canvas, size);
        break;
      case 'flask':
        _paintFlask(canvas, size);
        break;
      case 'droplet':
        _paintDroplet(canvas, size);
        break;
      case 'curcumin':
        _paintCurcumin(canvas, size);
        break;
      case 'leaf':
      default:
        _paintLeaf(canvas, size);
        break;
    }
  }

  void _paintLemon(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background soft shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.88), width: w * 0.7, height: h * 0.16),
      Paint()..color = Colors.black.withOpacity(0.08)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Green leaves in background
    final leafPaint = Paint()..color = const Color(0xFF4CAF50);
    final leafPath = Path();
    leafPath.moveTo(w * 0.45, h * 0.35);
    leafPath.quadraticBezierTo(w * 0.35, h * 0.1, w * 0.55, h * 0.05);
    leafPath.quadraticBezierTo(w * 0.6, h * 0.25, w * 0.45, h * 0.35);
    canvas.drawPath(leafPath, leafPaint);

    // Whole lemon (right side)
    final lemonPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFF176), Color(0xFFFBC02D)],
        center: Alignment(-0.2, -0.2),
      ).createShader(Rect.fromLTWH(w * 0.35, h * 0.2, w * 0.6, h * 0.65));

    final lemonPath = Path();
    lemonPath.moveTo(w * 0.45, h * 0.35);
    lemonPath.quadraticBezierTo(w * 0.95, h * 0.15, w * 0.92, h * 0.65);
    lemonPath.quadraticBezierTo(w * 0.85, h * 0.9, w * 0.5, h * 0.8);
    lemonPath.quadraticBezierTo(w * 0.3, h * 0.55, w * 0.45, h * 0.35);
    canvas.drawPath(lemonPath, lemonPaint);

    // Half cut lemon slice (front left)
    final sliceCenter = Offset(w * 0.36, h * 0.58);
    final sliceRadius = w * 0.32;

    // Rind
    final rindPaint = Paint()..color = const Color(0xFFFBC02D);
    canvas.drawCircle(sliceCenter, sliceRadius, rindPaint);

    // White pith
    final pithPaint = Paint()..color = const Color(0xFFFFFDE7);
    canvas.drawCircle(sliceCenter, sliceRadius * 0.92, pithPaint);

    // Pulp base
    final pulpPaint = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawCircle(sliceCenter, sliceRadius * 0.84, pulpPaint);

    // Segments (8 slices)
    final segmentPithPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      canvas.drawLine(
        sliceCenter,
        Offset(
          sliceCenter.dx + math.cos(angle) * sliceRadius * 0.84,
          sliceCenter.dy + math.sin(angle) * sliceRadius * 0.84,
        ),
        segmentPithPaint,
      );
    }

    // Slice center dot
    canvas.drawCircle(sliceCenter, sliceRadius * 0.12, pithPaint);
  }

  void _paintFlask(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.88), width: w * 0.6, height: h * 0.15),
      Paint()..color = Colors.black.withOpacity(0.08)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Flask outline path
    final flaskPath = Path();
    flaskPath.moveTo(w * 0.42, h * 0.15);
    flaskPath.lineTo(w * 0.42, h * 0.36);
    flaskPath.lineTo(w * 0.18, h * 0.8);
    flaskPath.quadraticBezierTo(w * 0.18, h * 0.88, w * 0.28, h * 0.88);
    flaskPath.lineTo(w * 0.72, h * 0.88);
    flaskPath.quadraticBezierTo(w * 0.82, h * 0.88, w * 0.82, h * 0.8);
    flaskPath.lineTo(w * 0.58, h * 0.36);
    flaskPath.lineTo(w * 0.58, h * 0.15);
    flaskPath.close();

    // Liquid fill inside flask
    final liquidPath = Path();
    liquidPath.moveTo(w * 0.28, h * 0.62);
    liquidPath.quadraticBezierTo(w * 0.5, h * 0.60, w * 0.72, h * 0.62);
    liquidPath.lineTo(w * 0.81, h * 0.8);
    liquidPath.quadraticBezierTo(w * 0.81, h * 0.86, w * 0.72, h * 0.86);
    liquidPath.lineTo(w * 0.28, h * 0.86);
    liquidPath.quadraticBezierTo(w * 0.19, h * 0.86, w * 0.19, h * 0.8);
    liquidPath.close();

    final liquidPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF97316)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(liquidPath, liquidPaint);

    // Bubbles
    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.6);
    canvas.drawCircle(Offset(w * 0.45, h * 0.72), w * 0.04, bubblePaint);
    canvas.drawCircle(Offset(w * 0.56, h * 0.78), w * 0.025, bubblePaint);
    canvas.drawCircle(Offset(w * 0.38, h * 0.8), w * 0.03, bubblePaint);

    // Glass stroke
    final glassPaint = Paint()
      ..color = const Color(0xFF0F8B7F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(flaskPath, glassPaint);

    // Lip of flask
    canvas.drawLine(Offset(w * 0.38, h * 0.15), Offset(w * 0.62, h * 0.15), glassPaint);
  }

  void _paintDroplet(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final dropPath = Path();
    dropPath.moveTo(w * 0.5, h * 0.12);
    dropPath.cubicTo(w * 0.85, h * 0.55, w * 0.88, h * 0.82, w * 0.5, h * 0.88);
    dropPath.cubicTo(w * 0.12, h * 0.82, w * 0.15, h * 0.55, w * 0.5, h * 0.12);
    dropPath.close();

    final dropPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF2563EB), Color(0xFF1D4ED8)],
        center: Alignment(-0.3, -0.3),
        radius: 0.9,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(dropPath, dropPaint);

    // Glossy shine highlight
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;

    final shinePath = Path();
    shinePath.moveTo(w * 0.38, h * 0.45);
    shinePath.quadraticBezierTo(w * 0.32, h * 0.65, w * 0.42, h * 0.78);
    canvas.drawPath(shinePath, shinePaint);
  }

  void _paintCurcumin(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Glowing spheres / curcumin granules
    final colors = [
      const Color(0xFFF43F5E),
      const Color(0xFFFB7185),
      const Color(0xFFFDA4AF),
    ];

    void drawSphere(Offset center, double radius, Color c) {
      final p = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, c, c.withOpacity(0.9)],
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, p);
    }

    drawSphere(Offset(w * 0.35, h * 0.65), w * 0.22, colors[0]);
    drawSphere(Offset(w * 0.65, h * 0.68), w * 0.19, colors[1]);
    drawSphere(Offset(w * 0.5, h * 0.42), w * 0.24, colors[0]);
    drawSphere(Offset(w * 0.28, h * 0.45), w * 0.15, colors[2]);
    drawSphere(Offset(w * 0.72, h * 0.48), w * 0.16, colors[2]);
  }

  void _paintLeaf(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final leafPath = Path();
    leafPath.moveTo(w * 0.2, h * 0.8);
    leafPath.cubicTo(w * 0.15, h * 0.3, w * 0.6, h * 0.1, w * 0.85, h * 0.15);
    leafPath.cubicTo(w * 0.9, h * 0.6, w * 0.6, h * 0.85, w * 0.2, h * 0.8);
    leafPath.close();

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF34D399), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(leafPath, leafPaint);

    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * 0.25, h * 0.75), Offset(w * 0.75, h * 0.25), veinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
