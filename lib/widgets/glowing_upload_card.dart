import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'painters/gradient_border_painter.dart';

class GlowingUploadCard extends StatelessWidget {
  const GlowingUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rectangle 8, 6, 7 (Glow effect shadows)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                // Rectangle 8 (blur 6px -> blurRadius 12)
                BoxShadow(
                  color: const Color(0xFF396FDB).withValues(alpha: 0.45),
                  blurRadius: 12.0,
                  spreadRadius: 2.0,
                ),
                // Rectangle 6 & 7 (blur 2px -> blurRadius 4)
                BoxShadow(
                  color: const Color(0xFF396FDB).withValues(alpha: 0.35),
                  blurRadius: 4.0,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
          // Frame 48096403 (Card background + Gradient Border)
          CustomPaint(
            painter: GradientBorderPainter(
              width: 1.0,
              borderRadius: 16.0,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8CDDF6),
                  Color(0xFF4770C2),
                  Color(0xFF1D305A),
                ],
                stops: [0.0, 0.1269, 1.0],
              ),
            ),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xA6396FDB), // rgba(57, 111, 219, 0.66)
                    Color(0xA6213258), // rgba(33, 50, 88, 0.66)
                  ],
                  stops: [0.1351, 0.8175],
                ),
              ),
              alignment: Alignment.center,
              child: SizedBox(
                width: 35,
                height: 35,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // The cloud shape
                    Positioned(
                      top: 0,
                      child: SvgPicture.asset(
                        'assets/images/bulut.svg',
                        width: 35,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // The arrow box overlapping the bottom of the cloud (upload.png contains the white rounded box and cutout arrow)
                    Positioned(
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/upload.png',
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
