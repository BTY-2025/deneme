import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class FileCard extends StatelessWidget {
  final String filename;
  final String sizeText;
  final String timeText;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FileCard({
    super.key,
    required this.filename,
    required this.sizeText,
    required this.timeText,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 160,
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2), // rgba(0, 0, 0, 0.2)
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2), // rgba(255, 255, 255, 0.2)
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Frame 48096407 (Top Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rectangle 9 (PDF Logo)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/pdfimoji.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Menu dot (heroicons-outline:dots-vertical)
              Builder(
                builder: (iconContext) {
                  return GestureDetector(
                    onTap: () {
                      final RenderBox renderBox = iconContext.findRenderObject() as RenderBox;
                      final offset = renderBox.localToGlobal(Offset.zero);

                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.5),
                        builder: (context) {
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                              Positioned(
                                top: offset.dy + 24,
                                right: MediaQuery.of(context).size.width - offset.dx - 16,
                                child: Material(
                                  color: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                      child: Container(
                                        width: 202,
                                        height: 104,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: const RadialGradient(
                                            center: Alignment(0.8, -0.6),
                                            radius: 1.5,
                                            colors: [
                                              Color(0xB3141414), // rgba(20, 20, 20, 0.7)
                                              Color(0xB30F0E0E), // rgba(15, 14, 14, 0.7)
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                if (onDelete != null) {
                                                  onDelete!();
                                                }
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/delete.svg',
                                                    width: 24,
                                                    height: 24,
                                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'common.delete_files'.tr(),
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
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Download clicked for $filename')),
                                                );
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/indirme.svg',
                                                    width: 24,
                                                    height: 24,
                                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'common.download'.tr(),
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 16,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12), // gap: 12px
          // Frame 48096406 (Text Stack)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Frame 48096391 (Sub-stack)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Q4 Annual Report.pdf text
                    Text(
                      filename,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 24.0 / 15.0, // line-height 24px (160%)
                          letterSpacing: -0.3, // -0.02em (-2%)
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), // gap: 4px
                    // 24 pages - 2.4 MB text
                    Text(
                      sizeText,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: TextStyle(
                          fontSize: 12, // 12px from Figma specs
                          fontWeight: FontWeight.w500,
                          height: 16.0 / 12.0, // line-height 16px (133%)
                          letterSpacing: -0.18, // -0.015em (-1.5%)
                          color: Colors.white.withValues(alpha: 0.6), // rgba(255, 255, 255, 0.6)
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // 2h ago text
                Text(
                  timeText,
                  style: GoogleFonts.getFont(
                    'Inter',
                    textStyle: TextStyle(
                      fontSize: 12, // 12px from Figma specs
                      fontWeight: FontWeight.w500,
                      height: 16.0 / 12.0, // line-height 16px (133%)
                      letterSpacing: -0.18, // -0.015em (-1.5%)
                      color: Colors.white.withValues(alpha: 0.6), // rgba(255, 255, 255, 0.6)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
