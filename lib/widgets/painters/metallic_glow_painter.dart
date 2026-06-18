import 'package:flutter/material.dart';

class MetallicGlowPainter extends CustomPainter {
  final Color startColor;
  final Color endColor;
  final double borderRadius;

  MetallicGlowPainter({
    required this.startColor,
    required this.endColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Calculate a brighter version of startColor for the top-left highlight
    final Color highlightColor = Color.lerp(Colors.white, startColor, 0.3) ?? Colors.white;

    // Linear gradient for the metallic rim
    final Gradient borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [highlightColor, startColor, endColor],
      stops: const [0.0, 0.5, 1.0],
    );

    // Helper function to draw a blurred border
    void drawGlowingBorder(double blurSigma, double strokeWidth) {
      final Paint paint = Paint()
        ..shader = borderGradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..blendMode = BlendMode.plus;

      if (blurSigma > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
      }

      canvas.drawRRect(rrect, paint);
    }

    // Figma Rectangle 8: 4.21px blur (CSS filter blur is roughly equal to sigma)
    drawGlowingBorder(4.21, 0.7);

    // Figma Rectangle 6 & 7: 1.4px blur (Drawn twice for intensity)
    drawGlowingBorder(1.4, 0.7);
    drawGlowingBorder(1.4, 0.7);
  }

  @override
  bool shouldRepaint(covariant MetallicGlowPainter oldDelegate) {
    return oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
