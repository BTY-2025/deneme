import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class RecentFileRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RecentFileRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon + Text
          Expanded(
            child: Row(
              children: [
                // Rectangle 9
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/pdfimoji.png',
                    width: 40,
                    height: 42,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                // Texts (Frame 48096391)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 22.0 / 15.0,
                            color: Colors.white,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
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
                ),
              ],
            ),
          ),
          // Right side: dots menu (Frame 96)
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
                          // Invisible barrier to dismiss the dialog
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              behavior: HitTestBehavior.opaque,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          // The dropdown menu
                          Positioned(
                            top: offset.dy + 24, // Just below the icon
                            right: MediaQuery.of(context).size.width - offset.dx - 16, // Align to icon right
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
                                        // Delete Files
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
                                        // Download
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Download clicked for $title')),
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
}
