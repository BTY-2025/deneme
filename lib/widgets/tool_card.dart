import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'painters/metallic_glow_painter.dart';

class ToolCard extends StatelessWidget {
  final String title;
  final Color startColor;
  final Color endColor;
  final Widget iconWidget;
  final bool useRawIcon;
  final bool useGlow;
  final VoidCallback? onTap;

  const ToolCard({
    super.key,
    required this.title,
    required this.startColor,
    required this.endColor,
    required this.iconWidget,
    this.useRawIcon = false,
    this.useGlow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Glowing Icon Container (Frame 48096405)
          SizedBox(
            width: 45,
            height: 45,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Frame 48096403 (Actual container / raw icon widget)
                Positioned.fill(
                  child: useRawIcon
                      ? OverflowBox(
                          minWidth: 0,
                          maxWidth: double.infinity,
                          minHeight: 0,
                          maxHeight: double.infinity,
                          child: iconWidget,
                        )
                      : CustomPaint(
                          painter: useGlow
                              ? MetallicGlowPainter(
                                  startColor: startColor,
                                  endColor: endColor,
                                  borderRadius: 11.25,
                                )
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.25),

                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  startColor.withValues(alpha: 0.66),
                                  endColor.withValues(alpha: 0.66),
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Inner Drop Shadow
                                Positioned(
                                  top: 1.4,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.15), BlendMode.srcIn),
                                    child: iconWidget,
                                  ),
                                ),
                                // Native SVG (preserves its own gradients)
                                iconWidget,
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.getFont(
              'Inter',
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: -0.28,
                color: Colors.white,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
}
