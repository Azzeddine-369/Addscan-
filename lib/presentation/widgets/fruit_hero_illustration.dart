import 'package:flutter/material.dart';

class FruitHeroIllustration extends StatelessWidget {
  final double width;
  final double height;

  const FruitHeroIllustration({
    super.key,
    this.width = 110,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _HeroPainter(),
      ),
    );
  }
}

class _HeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Red Tomato / Apple (Left background)
    final redPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFF87171), Color(0xFFDC2626)],
        center: Alignment(-0.3, -0.3),
      ).createShader(Rect.fromCircle(center: Offset(w * 0.28, h * 0.65), radius: w * 0.26));
    canvas.drawCircle(Offset(w * 0.28, h * 0.65), w * 0.26, redPaint);

    // Tomato green calyx
    final calyxPaint = Paint()..color = const Color(0xFF15803D);
    canvas.drawCircle(Offset(w * 0.28, h * 0.42), w * 0.06, calyxPaint);

    // 2. Yellow Orange / Lemon (Right background)
    final yellowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFDE047), Color(0xFFEAB308)],
        center: Alignment(-0.2, -0.2),
      ).createShader(Rect.fromCircle(center: Offset(w * 0.72, h * 0.7), radius: w * 0.24));
    canvas.drawCircle(Offset(w * 0.72, h * 0.7), w * 0.24, yellowPaint);

    // 3. Green Foliage / Leaves (Top right)
    final leafPaint = Paint()..color = const Color(0xFF22C55E);
    final leafPath = Path();
    leafPath.moveTo(w * 0.65, h * 0.35);
    leafPath.quadraticBezierTo(w * 0.8, h * 0.15, w * 0.95, h * 0.3);
    leafPath.quadraticBezierTo(w * 0.8, h * 0.45, w * 0.65, h * 0.35);
    canvas.drawPath(leafPath, leafPaint);

    // 4. White Shield with Green Checkmark in Front Center
    final shieldRect = Rect.fromCenter(
      center: Offset(w * 0.52, h * 0.42),
      width: w * 0.52,
      height: h * 0.58,
    );

    // Shield shadow
    final shadowPath = _createShieldPath(shieldRect.translate(0, 4));
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Shield white body
    final shieldPath = _createShieldPath(shieldRect);
    canvas.drawPath(shieldPath, Paint()..color = Colors.white);

    // Shield green badge inside
    final innerShieldRect = Rect.fromCenter(
      center: Offset(w * 0.52, h * 0.42),
      width: w * 0.40,
      height: h * 0.46,
    );
    final innerPath = _createShieldPath(innerShieldRect);
    final badgePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(innerShieldRect);
    canvas.drawPath(innerPath, badgePaint);

    // Checkmark inside shield
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path();
    checkPath.moveTo(w * 0.43, h * 0.42);
    checkPath.lineTo(w * 0.49, h * 0.48);
    checkPath.lineTo(w * 0.61, h * 0.35);
    canvas.drawPath(checkPath, checkPaint);
  }

  Path _createShieldPath(Rect rect) {
    final path = Path();
    final left = rect.left;
    final top = rect.top;
    final right = rect.right;
    final bottom = rect.bottom;
    final cx = rect.center.dx;

    path.moveTo(left, top);
    path.lineTo(right, top);
    path.quadraticBezierTo(right, top + rect.height * 0.5, cx, bottom);
    path.quadraticBezierTo(left, top + rect.height * 0.5, left, top);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
