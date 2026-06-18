import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/painters/progress_circle_painter.dart';
import '../widgets/custom_back_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'pdf_active_chat_screen.dart';

class PdfChatScreen extends StatefulWidget {
  final String fileName;
  final String fileMeta;
  final String? filePath;

  const PdfChatScreen({
    super.key,
    required this.fileName,
    required this.fileMeta,
    this.filePath,
  });

  @override
  State<PdfChatScreen> createState() => _PdfChatScreenState();
}

class _PdfChatScreenState extends State<PdfChatScreen> {
  double _progress = 0.0;
  Timer? _timer;
  int _elapsedMs = 0;
  final int _totalDurationMs = 6000;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    const periodMs = 50;
    _timer = Timer.periodic(const Duration(milliseconds: periodMs), (timer) {
      setState(() {
        _elapsedMs += periodMs;
        if (_elapsedMs >= _totalDurationMs) {
          _progress = 1.0;
          _timer?.cancel();
        } else {
          _progress = _elapsedMs / _totalDurationMs;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int percent = (_progress * 100).toInt();

    // Time boundaries matching the CSS/specs
    final double step1Limit = 1.2 / 6.0;
    final double step2Limit = 3.7 / 6.0;

    // Step 1: Dosya Yüklendi
    String step1Status = 'process.waiting'.tr();
    Color step1Color = Colors.white.withValues(alpha: 0.2);
    if (_progress < step1Limit) {
      step1Status = 'process.processing'.tr();
      step1Color = const Color(0xFF57B4E0);
    } else {
      step1Status = 'process.completed_time'.tr(args: ['1.2s']);
      step1Color = const Color(0xFF34C759);
    }

    // Step 2: AI analiz yapıyor
    String step2Status = 'process.waiting'.tr();
    Color step2Color = Colors.white.withValues(alpha: 0.2);
    if (_progress >= step1Limit) {
      if (_progress < step2Limit) {
        step2Status = 'process.processing'.tr();
        step2Color = const Color(0xFF57B4E0);
      } else {
        step2Status = 'process.completed_time'.tr(args: ['2.5s']);
        step2Color = const Color(0xFF34C759);
      }
    }

    // Step 3: Sohbete başlatılıyor
    String step3Status = 'process.waiting'.tr();
    Color step3Color = Colors.white.withValues(alpha: 0.2);
    if (_progress >= step2Limit) {
      if (_progress < 1.0) {
        step3Status = 'process.processing'.tr();
        step3Color = const Color(0xFF57B4E0);
      } else {
        step3Status = 'process.completed_time'.tr(args: ['2.3s']);
        step3Color = const Color(0xFF34C759);
      }
    }

    final isCompleted = _progress >= 1.0;

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
                          // Top Bar
                          Row(
                            children: [
                              CustomBackButton(
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'tools.chat_with_pdf'.tr(),
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

                          // Circular Progress Indicator
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
                                      activeColor: const Color(0xFF57B4E0),
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
                                        isCompleted ? 'process.completed_caps'.tr() : 'process.processing_caps'.tr(),
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

                          // Title & Subtitle
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  isCompleted ? 'chat.chat_ready'.tr() : 'chat.chat_preparing'.tr(),
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
                                    isCompleted
                                        ? 'chat.chat_ready_desc'.tr()
                                        : 'chat.chat_preparing_desc'.tr(),
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
                              ],
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
                                        widget.fileName,
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
                                        widget.fileMeta,
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
                              children: [
                                // Step 1: Dosya Yüklendi
                                _buildStepRow(
                                  title: 'process.step1'.tr(),
                                  subtitle: step1Status,
                                  color: step1Color,
                                  iconWidget: Icon(
                                    Icons.check,
                                    color: step1Color,
                                    size: 18,
                                  ),
                                  bgBoxColor: step1Status.startsWith('process.completed'.tr()) || step1Status.startsWith('Tamamlandı') || step1Status.startsWith('Completed')
                                      ? const Color(0x3334C759)
                                      : const Color(0x1F57B4E0),
                                ),
                                const SizedBox(height: 12),
                                // Step 2: AI analiz yapıyor
                                _buildStepRow(
                                  title: 'process.step2'.tr(),
                                  subtitle: step2Status,
                                  color: step2Color,
                                  iconWidget: Icon(
                                    Icons.layers,
                                    color: step2Color,
                                    size: 18,
                                  ),
                                  bgBoxColor: step2Status.startsWith('process.completed'.tr()) || step2Status.startsWith('Tamamlandı') || step2Status.startsWith('Completed')
                                      ? const Color(0x3334C759)
                                      : step2Status.startsWith('process.processing'.tr()) || step2Status.startsWith('İşleniyor') || step2Status.startsWith('Processing')
                                          ? const Color(0x1A57B4E0)
                                          : Colors.white.withValues(alpha: 0.05),
                                ),
                                const SizedBox(height: 12),
                                // Step 3: Sohbete başlatılıyor
                                _buildStepRow(
                                  title: 'chat.step3'.tr(),
                                  subtitle: step3Status,
                                  color: step3Color,
                                  iconWidget: Icon(
                                    Icons.settings,
                                    color: step3Color,
                                    size: 18,
                                  ),
                                  bgBoxColor: step3Status.startsWith('process.completed'.tr()) || step3Status.startsWith('Tamamlandı') || step3Status.startsWith('Completed')
                                      ? const Color(0x3334C759)
                                      : step3Status.startsWith('process.processing'.tr()) || step3Status.startsWith('İşleniyor') || step3Status.startsWith('Processing')
                                          ? const Color(0x1A57B4E0)
                                          : Colors.white.withValues(alpha: 0.05),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
                  child: Column(
                    children: [
                      // Sohbete Başla
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isCompleted ? 1.0 : 0.4,
                          child: GestureDetector(
                            onTap: isCompleted
                                ? () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfActiveChatScreen(
                                          fileName: widget.fileName,
                                          fileMeta: widget.fileMeta,
                                          filePath: widget.filePath,
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
                                'chat.start_chat'.tr(),
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
                            'process.cancel_process'.tr(),
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
                ),
              ],
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
    required Widget iconWidget,
    required Color bgBoxColor,
  }) {
    return Row(
      children: [
        // Box Icon Container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgBoxColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: iconWidget,
        ),
        const SizedBox(width: 12),
        // Text Info Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ],
    );
  }
}
