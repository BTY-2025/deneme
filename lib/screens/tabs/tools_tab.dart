import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/tools_grid_card.dart';
import '../../widgets/glowing_upload_card.dart';
import '../../widgets/painters/dashed_border_painter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../pdf_summary_screen.dart';
import '../pdf_to_word_screen.dart';
import '../pdf_chat_screen.dart';

class ToolsTab extends StatefulWidget {
  final String? selectedFileName;
  final String? selectedFileMeta;
  final String? selectedFilePath;
  final VoidCallback onUploadTap;
  final Function(String name, String meta) onFileSelected;
  final int? initialToolIndex;

  const ToolsTab({
    super.key,
    required this.selectedFileName,
    required this.selectedFileMeta,
    this.selectedFilePath,
    required this.onUploadTap,
    required this.onFileSelected,
    this.initialToolIndex,
  });

  @override
  State<ToolsTab> createState() => _ToolsTabState();
}

class _ToolsTabState extends State<ToolsTab> {
  late int _selectedToolIndex;

  @override
  void initState() {
    super.initState();
    _selectedToolIndex = widget.initialToolIndex ?? 0;
  }

  @override
  void didUpdateWidget(ToolsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialToolIndex != oldWidget.initialToolIndex && widget.initialToolIndex != null) {
      setState(() {
        _selectedToolIndex = widget.initialToolIndex!;
      });
    }
  }

  String _getSelectedToolName() {
    switch (_selectedToolIndex) {
      case 0:
        return 'tools.pdf_summary'.tr();
      case 1:
        return 'tools.chat_pdf'.tr();
      case 2:
        return 'tools.pdf_to_word'.tr();
      default:
        return 'tools.pdf_summary'.tr();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dashboard.quick_tools'.tr(),
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 28.0 / 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'tools.ai_generated_summaries'.tr(),
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
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Upload PDF Box (Frame 48096392)
                  CustomPaint(
                    foregroundPainter: DashedBorderPainter(
                      color: const Color(0x80396FDB),
                      strokeWidth: 3.0,
                      borderRadius: 16.0,
                      dashPattern: const [3.0, 4.0],
                    ),
                    child: GestureDetector(
                      onTap: widget.onUploadTap,
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          minHeight: 200,
                        ),
                        padding: EdgeInsets.all(widget.selectedFileName == null ? 10 : 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xA6142446),
                              Color(0xA60F1827),
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
                        child: widget.selectedFileName == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const GlowingUploadCard(),
                                  Transform.translate(
                                    offset: const Offset(0, -8),
                                    child: SizedBox(
                                      width: 378,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'tools.upload_pdf_title'.tr(),
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                height: 28.0 / 20.0,
                                                letterSpacing: -0.4,
                                                color: Colors.white,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'tools.upload_pdf_subtitle'.tr(),
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
                                      widget.selectedFileName!,
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
                                    widget.selectedFileMeta!,
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

                  // AI Assistant section title (AI Asistant - as spelled in design)
                  Text(
                    'tools.ai_assistant'.tr(),
                    style: GoogleFonts.getFont(
                      'Inter',
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 22.0 / 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tools grid (Frame 95)
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 191.0 / 135.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ToolsGridCard(
                        title: 'tools.pdf_summary'.tr(),
                        description: 'tools.ai_generated_summaries'.tr(),
                        startColor: const Color(0xFFD15DC8),
                        endColor: const Color(0xFF77166F),
                        iconWidget: SvgPicture.asset(
                          'assets/images/sumaryicon.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        isSelected: _selectedToolIndex == 0,
                        onTap: () => setState(() => _selectedToolIndex = 0),
                        activeGlowColor: const Color(0xFFCA2DBD),
                      ),
                      ToolsGridCard(
                        title: 'tools.chat_pdf'.tr(),
                        description: 'tools.chat_with_pdf'.tr(),
                        startColor: const Color(0xFF34C759),
                        endColor: const Color(0xFF105421),
                        iconWidget: SvgPicture.asset(
                          'assets/images/chaticon.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        isSelected: _selectedToolIndex == 1,
                        onTap: () => setState(() => _selectedToolIndex = 1),
                        activeGlowColor: const Color(0xFF34C759),
                      ),
                      ToolsGridCard(
                        title: 'tools.pdf_to_word'.tr(),
                        description: 'tools.pdf_to_word_desc'.tr(),
                        startColor: const Color(0xFF396FDB),
                        endColor: const Color(0xFF213258),
                        iconWidget: SvgPicture.asset(
                          'assets/images/pdfwordicon.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        isSelected: _selectedToolIndex == 2,
                        onTap: () => setState(() => _selectedToolIndex = 2),
                        activeGlowColor: const Color(0xFF396FDB),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Start Converting Button (Frame 48096401)
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Blur/Shadow effects
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF83E0FB).withValues(alpha: 0.15),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                // Actual Button
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.selectedFileName != null && widget.selectedFileMeta != null) {
                        if (_selectedToolIndex == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfSummaryScreen(
                                fileName: widget.selectedFileName!,
                                fileMeta: widget.selectedFileMeta!,
                                filePath: widget.selectedFilePath,
                              ),
                            ),
                          );
                        } else if (_selectedToolIndex == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfChatScreen(
                                fileName: widget.selectedFileName!,
                                fileMeta: widget.selectedFileMeta!,
                                filePath: widget.selectedFilePath,
                              ),
                            ),
                          );
                        } else if (_selectedToolIndex == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfToWordScreen(
                                fileName: widget.selectedFileName!,
                                fileMeta: widget.selectedFileMeta!,
                                filePath: widget.selectedFilePath,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${'tools.start_converting'.tr()} - ${_getSelectedToolName()}!'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('common.please_select_pdf'.tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        widget.onUploadTap();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFF83E0FB).withValues(alpha: 0.44),
                          width: 1,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF3965DA),
                            Color(0xFF5EC8E2),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/startbuton.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'tools.start_converting'.tr(),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
