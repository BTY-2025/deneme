import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'painters/metallic_glow_painter.dart';

class ToolsGridCard extends StatelessWidget {
  final String title;
  final String description;
  final Color startColor;
  final Color endColor;
  final Widget iconWidget;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeGlowColor;

  const ToolsGridCard({
    super.key,
    required this.title,
    required this.description,
    required this.startColor,
    required this.endColor,
    required this.iconWidget,
    required this.isSelected,
    required this.onTap,
    required this.activeGlowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Background container with glow/shadow
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeGlowColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.2),
              border: Border.all(
                color: isSelected
                    ? activeGlowColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: activeGlowColor.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Glowing Icon Container (Frame 48096405)
                SizedBox(
                  width: 45,
                  height: 45,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Frame 48096403 (Actual container with gradient)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MetallicGlowPainter(
                            startColor: startColor,
                            endColor: endColor,
                            borderRadius: 11.25,
                          ),
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
                // Text items
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 22.0 / 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16.0 / 12.0,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Checkmark Tick badge in top right (Frame 96 / tick-circle)
          if (isSelected)
            Positioned(
              top: 10.5,
              right: 10.5,
              child: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: activeGlowColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
