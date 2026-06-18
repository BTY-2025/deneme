import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/painters/progress_circle_painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'pdf_summary_details_screen.dart';
import '../widgets/custom_back_button.dart';
import '../services/openai_service.dart';

class PdfSummaryScreen extends StatefulWidget {
  final String fileName;
  final String fileMeta;
  final String? filePath;

  const PdfSummaryScreen({
    super.key,
    required this.fileName,
    required this.fileMeta,
    this.filePath,
  });

  @override
  State<PdfSummaryScreen> createState() => _PdfSummaryScreenState();
}

class _PdfSummaryScreenState extends State<PdfSummaryScreen> {
  double _progress = 0.0;
  Timer? _timer;
  int _elapsedMs = 0;
  final int _totalDurationMs = 6000;
  bool _isApiLoading = true;
  String _summaryText = "";
  List<String> _highlightsList = [];
  int _realPages = 1;
  int _realWords = 0;
  int _realReadingTime = 1;

  final bool _hasSelectedFile = true;
  late String _selectedFileName;
  late String _selectedFileMeta;

  @override
  void initState() {
    super.initState();
    _selectedFileName = widget.fileName;
    _selectedFileMeta = widget.fileMeta;
    _startSimulation();
    _fetchOpenAiSummary();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchOpenAiSummary() async {
    try {
      String pdfText = "";
      if (widget.filePath != null) {
        pdfText = await OpenAiService.extractTextFromPdf(widget.filePath!);
      }

      // Calculate pages
      int pages = 12;
      if (widget.fileMeta.contains('·')) {
        final parts = widget.fileMeta.split('·');
        if (parts.length >= 2) {
          final digits = RegExp(r'\d+').firstMatch(parts[1]);
          if (digits != null) {
            pages = int.tryParse(digits.group(0) ?? '12') ?? 12;
          }
        }
      }

      // Calculate words
      int words = 0;
      if (pdfText.isNotEmpty) {
        words = pdfText.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      } else {
        words = pages * 250;
      }

      // Estimate reading time
      int readTime = (words / 200).ceil();
      if (readTime < 1) readTime = 1;

      final result = await OpenAiService.getSummary(pdfText, widget.fileName);
      if (mounted) {
        setState(() {
          _summaryText = result['summary'] ?? '';
          _highlightsList = List<String>.from(result['highlights'] ?? []);
          _realPages = pages;
          _realWords = words;
          _realReadingTime = readTime;
          _isApiLoading = false;
          if (_progress >= 0.99) {
            _progress = 1.0;
            _timer?.cancel();
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching summary: $e');
      if (mounted) {
        setState(() {
          _summaryText = "Summary failed to generate from OpenAI: $e";
          _highlightsList = [
            "Please check API Key",
            "Please check internet connection",
            "Try again later"
          ];
          _isApiLoading = false;
          if (_progress >= 0.99) {
            _progress = 1.0;
            _timer?.cancel();
          }
        });
      }
    }
  }

  void _startSimulation() {
    const periodMs = 50;
    _timer = Timer.periodic(const Duration(milliseconds: periodMs), (timer) {
      setState(() {
        _elapsedMs += periodMs;
        if (_elapsedMs >= _totalDurationMs) {
          if (_isApiLoading) {
            _progress = 0.99;
          } else {
            _progress = 1.0;
            _timer?.cancel();
          }
        } else {
          _progress = _elapsedMs / _totalDurationMs;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final int percent = (_progress * 100).toInt();

    // Determine state of steps
    final double step1Limit = 1.2 / 6.0;
    final double step2Limit = 3.7 / 6.0;

    String step1Status = 'process.waiting'.tr();
    Color step1Color = Colors.white.withValues(alpha: 0.2);
    if (_hasSelectedFile) {
      if (_progress < step1Limit) {
        step1Status = 'process.processing'.tr();
        step1Color = const Color(0xFF57B4E0);
      } else {
        step1Status = 'process.completed_time'.tr(args: ['1.2s']);
        step1Color = const Color(0xFF34C759);
      }
    }

    // Step 2: AI Analyzing (1.2s to 3.7s)
    String step2Status = 'process.waiting'.tr();
    Color step2Color = Colors.white.withValues(alpha: 0.2);
    if (_hasSelectedFile) {
      if (_progress >= step1Limit && _progress < step2Limit) {
        step2Status = 'process.processing'.tr();
        step2Color = const Color(0xFF57B4E0);
      } else if (_progress >= step2Limit) {
        step2Status = 'process.completed_time'.tr(args: ['2.5s']);
        step2Color = const Color(0xFF34C759);
      }
    }

    // Step 3: Summarizing (3.7s to 6.0s)
    String step3Status = 'process.waiting'.tr();
    Color step3Color = Colors.white.withValues(alpha: 0.2);
    if (_hasSelectedFile) {
      if (_progress >= step2Limit && _progress < 1.0) {
        step3Status = 'process.processing'.tr();
        step3Color = const Color(0xFF57B4E0);
      } else if (_progress >= 1.0) {
        step3Status = 'process.completed'.tr();
        step3Color = const Color(0xFF34C759);
      }
    }

    final isCompleted = _hasSelectedFile && _progress >= 1.0;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 24.0),
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

                  // Progress Circle + Texts (Frame 316)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Circular Progress Indicator (Group 315)
                        Center(
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(160, 160),
                                  painter: ProgressCirclePainter(
                                    progress: _progress,
                                    activeColor: const Color(0xFF3E63EF),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$percent%',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          height: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      !_hasSelectedFile
                                          ? 'process.waiting_caps'.tr()
                                          : isCompleted
                                              ? 'process.completed_caps'.tr()
                                              : 'process.processing_caps'.tr(),
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title & Subtitle (Frame 1597878583)
                        Text(
                          !_hasSelectedFile
                              ? 'process.please_select_file'.tr()
                              : isCompleted
                                  ? 'process.summary_ready'.tr()
                                  : 'process.generating_summary'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            !_hasSelectedFile
                                ? 'process.select_file_desc'.tr()
                                : isCompleted
                                    ? 'process.summary_ready_desc'.tr()
                                    : 'process.generating_summary_desc'.tr(),
                            style: GoogleFonts.getFont(
                              'Inter',
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                color: Colors.white.withValues(alpha: 0.65),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Selected File Card (Frame 48096390)
                        Container(
                          height: 69,
                          padding: const EdgeInsets.all(12),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF34C759).withValues(alpha: 0.5),
                              width: 1.5,
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
                                      _selectedFileName,
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 22.0 / 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedFileMeta,
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 16.0 / 12.0,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Step Progress Card (Frame 48096392)
                        Container(
                          padding: const EdgeInsets.all(16),
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
                            children: [
                              _buildStepRow(
                                title: 'process.step1'.tr(),
                                subtitle: step1Status,
                                color: step1Color,
                                icon: Icons.check,
                                bgBoxColor: step1Status.startsWith('process.completed'.tr()) || step1Status.startsWith('Tamamlandı') || step1Status.startsWith('Completed')
                                    ? const Color(0x3334C759)
                                    : step1Status.startsWith('process.processing'.tr()) || step1Status.startsWith('İşleniyor') || step1Status.startsWith('Processing')
                                        ? const Color(0x1F57B4E0)
                                        : Colors.white.withValues(alpha: 0.05),
                              ),
                              const SizedBox(height: 16),
                              _buildStepRow(
                                title: 'process.step2'.tr(),
                                subtitle: step2Status,
                                color: step2Color,
                                icon: Icons.layers,
                                bgBoxColor: step2Status.startsWith('process.completed'.tr()) || step2Status.startsWith('Tamamlandı') || step2Status.startsWith('Completed')
                                    ? const Color(0x3334C759)
                                    : step2Status.startsWith('process.processing'.tr()) || step2Status.startsWith('İşleniyor') || step2Status.startsWith('Processing')
                                        ? const Color(0x1F57B4E0)
                                        : Colors.white.withValues(alpha: 0.05),
                              ),
                              const SizedBox(height: 16),
                              _buildStepRow(
                                title: 'process.step3'.tr(),
                                subtitle: step3Status,
                                color: step3Color,
                                icon: Icons.settings,
                                bgBoxColor: step3Status.startsWith('process.completed'.tr()) || step3Status.startsWith('Tamamlandı') || step3Status.startsWith('Completed')
                                    ? const Color(0x3334C759)
                                    : step3Status.startsWith('process.processing'.tr()) || step3Status.startsWith('İşleniyor') || step3Status.startsWith('Processing')
                                        ? const Color(0x1F57B4E0)
                                        : Colors.white.withValues(alpha: 0.05),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Buttons
                  Column(
                    children: [
                      // Özeti İncele
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isCompleted ? 1.0 : 0.4,
                          child: GestureDetector(
                            onTap: isCompleted
                                ? () {
                                    String pagesStr = _realPages.toString();
                                    String wordsStr = _realWords >= 1000 
                                        ? '${(_realWords / 1000).toStringAsFixed(1)}K' 
                                        : _realWords.toString();
                                    String timeStr = "~$_realReadingTime dk";

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfSummaryDetailsScreen(
                                          fileName: _selectedFileName,
                                          pages: pagesStr,
                                          words: wordsStr,
                                          readingTime: timeStr,
                                          highlights: _highlightsList.isNotEmpty ? _highlightsList : [
                                            "Yeni Asya pazarlarına başarılı giriş",
                                            "Yıllık gelir %18 büyüme ile rekor kırdı",
                                            "Dijital dönüşüm yatırım getirisi %340’a ulaştı"
                                          ],
                                          summaryText: _summaryText.isNotEmpty ? _summaryText : "No summary generated.",
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(99999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'process.view_summary'.tr(),
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // İşlemi İptal Et
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99999),
                            ),
                          ),
                          child: Text(
                            isCompleted ? 'process.go_back'.tr() : 'process.cancel_process'.tr(),
                            style: GoogleFonts.getFont(
                              'Inter',
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Color bgBoxColor,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgBoxColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.getFont(
                'Inter',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.getFont(
                'Inter',
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


