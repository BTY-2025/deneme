import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_back_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdfaireader/widgets/db_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSummaryDetailsScreen extends StatelessWidget {
  final String fileName;
  final String pages;
  final String words;
  final String readingTime;
  final List<String> highlights;
  final String summaryText;

  const PdfSummaryDetailsScreen({
    super.key,
    required this.fileName,
    required this.pages,
    required this.words,
    required this.readingTime,
    required this.highlights,
    required this.summaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050E22),
      body: Stack(
        children: [
          // Background Gradient Layer
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.3),
                  radius: 0.7,
                  colors: [
                    Color(0x1A83E0FB),
                    Color(0x00000000),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Bar (Frame 95)
                          Row(
                            children: [
                              CustomBackButton(
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'tools.pdf_summary'.tr(),
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 28.0 / 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // File Card Row: Özet Hazır! (Frame 48096390)
                          Container(
                            height: 66,
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
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
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'process.summary_ready'.tr(),
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
                                      const SizedBox(height: 2),
                                      Text(
                                        fileName,
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
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF34C759),
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // AI Summary Card (Frame 48096391)
                          Container(
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header row: AI Özet + GPT-4o Badge
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF57B4E0).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/images/aiözet.svg',
                                            width: 23,
                                            height: 23,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'summary.ai_summary'.tr(),
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
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            readingTime,
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                height: 18.0 / 12.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Summary Text
                                Text(
                                  summaryText,
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 20.0 / 14.0,
                                      color: Colors.white.withValues(alpha: 0.65),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Divider
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 10),

                                // Metrics section (SAYFA, KELİME, OKUMA)
                                Row(
                                  children: [
                                    _buildMetricColumn('summary.page'.tr(), pages),
                                    const SizedBox(width: 10),
                                    _buildVerticalDivider(),
                                    const SizedBox(width: 10),
                                    _buildMetricColumn('summary.word'.tr(), words),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Key Highlights Card (Frame 48096392)
                          Container(
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'summary.key_highlights'.tr(),
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 22.0 / 14.0,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: [
                                    for (int i = 0; i < highlights.length; i++) ...[
                                      if (i > 0) const SizedBox(height: 8),
                                      _buildHighlightRow(highlights[i]),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Buttons (Frame 316)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
                  child: Column(
                    children: [
                      // Özeti İndir
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => _downloadSummary(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99999),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/indir.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'summary.download_summary'.tr(),
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 20.0 / 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Share
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Paylaşım paneli açıldı!')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99999),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/paylas.svg',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'common.share'.tr(),
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 20.0 / 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.getFont(
              'Inter',
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 20.0 / 14.0,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.getFont(
              'Inter',
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 20.0 / 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 1,
        height: 47.5,
        color: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildHighlightRow(String text) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF57B4E0).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check,
              color: Color(0xFF57B4E0),
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.getFont(
                'Inter',
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 22.0 / 14.0,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
        ],
      );
  }

  Future<void> _downloadSummary(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      String baseName = fileName.endsWith('.pdf')
          ? fileName.substring(0, fileName.length - 4)
          : fileName;
      String summaryFileName = "${baseName}_Summary.pdf";

      // Download font for Turkish character support
      pw.Font? ttfFont;
      try {
        final response = await http.get(Uri.parse('https://github.com/google/fonts/raw/main/apache/roboto/static/Roboto-Regular.ttf')).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          ttfFont = pw.Font.ttf(response.bodyBytes.buffer.asByteData());
        }
      } catch (e) {
        debugPrint('Could not download Roboto font, falling back to system font: $e');
      }

      final pdf = pw.Document();

      // Renders text style using downloaded font if available
      pw.TextStyle textStyle({double fontSize = 12, bool isBold = false}) {
        return pw.TextStyle(
          font: ttfFont,
          fontSize: fontSize,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: PdfColors.black,
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'summary.ai_summary'.tr().toUpperCase(),
                  style: textStyle(fontSize: 24, isBold: true),
                ),
              ),
              pw.Text(
                '${'tools.selected_pdf'.tr()}: $fileName',
                style: textStyle(fontSize: 12, isBold: true),
              ),
              pw.SizedBox(height: 12),
              
              // Metrics Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('word.page'.tr(), style: textStyle(fontSize: 10, isBold: true)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('summary.word'.tr(), style: textStyle(fontSize: 10, isBold: true)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('summary.reading'.tr(), style: textStyle(fontSize: 10, isBold: true)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(pages, style: textStyle(fontSize: 12)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(words, style: textStyle(fontSize: 12)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(readingTime, style: textStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Summary
              pw.Text(
                'summary.ai_summary'.tr(),
                style: textStyle(fontSize: 16, isBold: true),
              ),
              pw.Divider(color: PdfColors.grey300),
              pw.Paragraph(
                text: summaryText,
                style: textStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 20),

              // Highlights
              pw.Text(
                'summary.key_highlights'.tr(),
                style: textStyle(fontSize: 16, isBold: true),
              ),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              ...highlights.map((highlight) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("• ", style: textStyle(fontSize: 12, isBold: true)),
                      pw.Expanded(
                        child: pw.Text(highlight, style: textStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                );
              }),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();

      String? resultPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Summary PDF',
        fileName: summaryFileName,
        type: FileType.any,
        bytes: pdfBytes,
      );

      if (resultPath != null) {
        if (defaultTargetPlatform != TargetPlatform.android) {
          try {
            final file = File(resultPath);
            await file.writeAsBytes(pdfBytes);
          } catch (e) {
            debugPrint('Manual write fallback error (safe to ignore if already written): $e');
          }
        }
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DbService.logUserAction(
            firebaseUid: currentUser.uid,
            actionType: 'pdf_summary',
            details: fileName,
          );
        }
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('word.download_success'.tr(args: [summaryFileName])),
            backgroundColor: const Color(0xFF34C759),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving summary PDF: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${'common.error'.tr()}: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

