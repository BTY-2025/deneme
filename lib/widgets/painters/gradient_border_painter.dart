import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  final double width;
  final double borderRadius;
  final Gradient gradient;

  GradientBorderPainter({
    this.width = 1.0,
    this.borderRadius = 16.0,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(width / 2, width / 2, size.width - width, size.height - width);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
