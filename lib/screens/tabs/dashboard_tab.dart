import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/file_card.dart';
import '../../widgets/tool_card.dart';
import '../../widgets/glowing_upload_card.dart';
import '../../widgets/painters/dashed_border_painter.dart';
import '../profile_screen.dart';
import '../../widgets/user_manager.dart';
import '../../widgets/auth_purchase_service.dart';

class DashboardTab extends StatelessWidget {
  final Size size;
  final String? selectedFileName;
  final String? selectedFileMeta;
  final VoidCallback onUploadTap;
  final Function(String name, String meta, String path) onFileSelected;
  final Function(String path) onDeleteFile;
  final VoidCallback onSeeAllClicked;
  final Function(int toolIndex) onToolSelected;
  final List<Map<String, String>> recentFiles;

  const DashboardTab({
    super.key,
    required this.size,
    required this.selectedFileName,
    required this.selectedFileMeta,
    required this.onUploadTap,
    required this.onFileSelected,
    required this.onDeleteFile,
    required this.onSeeAllClicked,
    required this.onToolSelected,
    required this.recentFiles,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Frame 48096337)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Info (Frame 48096387)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      // Frame 3 - User avatar container
                      Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF3E63EF),
                            Color(0xFF557FF1),
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'U',
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 24.0 / 18.0,
                            letterSpacing: -0.36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Greetings Stack (Frame 95)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'dashboard.welcome_prefix'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 18.0 / 14.0,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: UserManager.userNameNotifier,
                          builder: (context, userName, child) {
                            return Text(
                              userName,
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 24.0 / 18.0,
                                  letterSpacing: -0.36,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

                // Get Pro Badge (Frame 48096388)
                ValueListenableBuilder<bool>(
                  valueListenable: AuthPurchaseService.isPremiumNotifier,
                  builder: (context, isPremium, child) {
                    return GestureDetector(
                      onTap: isPremium
                          ? null
                          : () async {
                              await AuthPurchaseService.buyPremium();
                            },
                      child: Container(
                        width: 115,
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2433),
                          borderRadius: BorderRadius.circular(99999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/diamond.png',
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                isPremium ? 'Premium' : 'dashboard.get_pro'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.0, // 100% line height
                                    letterSpacing: 0.0, // 0% letter spacing
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32), // Gap: 32px between Header and Upload box

            // PDF Upload Box (Frame 48096392)
            CustomPaint(
              foregroundPainter: DashedBorderPainter(
                color: const Color(0x80396FDB), // Bright blue with opacity
                strokeWidth: 3.0,
                borderRadius: 16.0,
                dashPattern: const [3.0, 4.0], // Distinct square dotted styling
              ),
              child: GestureDetector(
                onTap: onUploadTap,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 200,
                  ),
                  padding: EdgeInsets.all(selectedFileName == null ? 10 : 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xA6142446), // rgba(20, 36, 70, 0.65)
                        Color(0xA60F1827), // rgba(15, 24, 39, 0.65)
                      ],
                      stops: [0.3077, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: selectedFileName == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Glowing Upload Icon Box (Frame 48096405)
                            const GlowingUploadCard(),
                            Transform.translate(
                              offset: const Offset(0, -8), // Bring text closer to the image
                              child: SizedBox(
                                width: 378,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'dashboard.upload_pdf'.tr(),
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          height: 28.0 / 20.0,
                                          letterSpacing: -0.4, // -0.02em
                                          color: Colors.white,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6), // gap: 6px
                                    Text(
                                      'dashboard.click_to_upload'.tr(),
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 20.0 / 14.0,
                                          color: Colors.white.withValues(alpha: 0.75),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFF34C759).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF34C759),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Color(0xFF34C759),
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'tools.selected_pdf'.tr(),
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                selectedFileName!,
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedFileMeta!,
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'tools.change_file'.tr(),
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF60CAF7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Recent Files Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Frame 48096390)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'dashboard.recent_files'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24.0 / 16.0,
                          letterSpacing: -0.32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (recentFiles.isNotEmpty)
                      GestureDetector(
                        onTap: onSeeAllClicked,
                        child: Text(
                          'dashboard.see_all'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 18.0 / 12.0,
                              color: Color(0xFF60CAF7),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Horizontal Scroll View (Frame 95)
                recentFiles.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open_outlined,
                              color: Colors.white.withValues(alpha: 0.4),
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'dashboard.no_recent_files'.tr(),
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.none,
                          itemCount: recentFiles.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final file = recentFiles[index];
                            final name = file['name'] ?? '';
                            final meta = file['meta'] ?? '';
                            final path = file['path'] ?? '';
                            final time = file['time'] ?? '';

                            String pagesAndSize = meta;
                            if (meta.contains('·')) {
                              final parts = meta.split('·');
                              if (parts.length >= 2) {
                                pagesAndSize = '${parts[1].trim()} - ${parts[0].trim()}';
                              }
                            }

                             return FileCard(
                              filename: name,
                              sizeText: pagesAndSize,
                              timeText: time,
                              onTap: () {
                                onFileSelected(name, meta, path);
                              },
                              onDelete: () {
                                onDeleteFile(path);
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Tools Section (Frame 96)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dashboard.quick_tools'.tr(),
                  style: GoogleFonts.getFont(
                    'Inter',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 24.0 / 16.0,
                      letterSpacing: -0.32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Row of Tools (Frame 316)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToolCard(
                      title: 'tools.pdf_to_word'.tr(),
                      startColor: const Color(0xFF396FDB),
                      endColor: const Color(0xFF213258),
                      iconWidget: SvgPicture.asset(
                        'assets/images/pdfwordicon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      onTap: () {
                        onToolSelected(2);
                      },
                    ),
                    ToolCard(
                      title: 'tools.chat_pdf'.tr(),
                      startColor: const Color(0xFF34C759),
                      endColor: const Color(0xFF105421),
                      iconWidget: SvgPicture.asset(
                        'assets/images/chaticon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      onTap: () {
                        onToolSelected(1);
                      },
                    ),
                    ToolCard(
                      title: 'tools.pdf_summary'.tr(),
                      startColor: const Color(0xFFD15DC8),
                      endColor: const Color(0xFF77166F),
                      iconWidget: SvgPicture.asset(
                        'assets/images/sumaryicon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      onTap: () {
                        onToolSelected(0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
