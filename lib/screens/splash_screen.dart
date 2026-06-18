import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdfaireader/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final figmaHeight = 927.0;
    
    // Proportional calculations
    final topMargin = size.height * (20.0 / figmaHeight);
    final imageShift = size.height * (50.0 / figmaHeight);
    final contentHeight = size.height * (419.0 / figmaHeight);
    final contentTopPadding = size.height * (10.0 / figmaHeight);
    final contentBottomPadding = size.height * (48.0 / figmaHeight);

    // Set system status bar style to match the dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF050E22),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Radial Gradient Background behind the image
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0, -0.3),
                    radius: 0.7,
                    colors: [
                      Color(0x1A83E0FB), // Very subtle cyan glow in center
                      Color(0x00000000), // Transparent edge
                    ],
                  ),
                ),
              ),
            ),

            // App Main Logo/Illustration (Locked Layer)
            Positioned(
              top: topMargin - imageShift,
              left: 0,
              right: 0,
              height: size.height * 0.52, // Fixed proportion of screen height
              child: Image.asset(
                'assets/images/image_3.png',
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),

            // Content Area (Corresponds to "Frame 2" from CSS)
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 0.0,
              height: contentHeight,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 382),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        clipBehavior: Clip.none,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                0.0,
                                contentTopPadding,
                                0.0,
                                contentBottomPadding,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Frame 48096400 (Logo, title, heading, subtitle group)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Frame 48096398 (Branding Row)
                                      Row(
                                        children: [
                                          // Frame 3 (Logo container)
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10.2857),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.2857),
                                              child: Image.asset(
                                                'assets/images/pdfreader_logo_1.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // PDF AI Reader Title
                                          Text(
                                            'PDF AI Reader',
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                height: 24.0 / 18.0, // 24px line height (133%)
                                                letterSpacing: -0.36, // -0.02em (-2%)
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8), // Gap: 8px between Frame 48096398 and Frame 48096399
                                      // Frame 48096399 (Heading and Subtitle Column)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Smarter PDFs, Better Decisions.
                                          Text(
                                            'splash.title'.tr(),
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w500,
                                                height: 44.0 / 36.0, // 44px line-height (122%)
                                                letterSpacing: -0.72, // -0.02em (-2%)
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12), // Gap: 12px
                                          // Subtitle
                                          Text(
                                            'splash.subtitle'.tr(),
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                height: 24.0 / 16.0, // 24px line-height (150%)
                                                color: Colors.white.withValues(alpha: 0.75),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Frame 48096402 (Glowing Button Structure)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Rectangle 3 (Blur: 2px, Border: 2px solid #83E0FB)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(9999),
                                              border: Border.all(
                                                color: const Color(0xFF83E0FB),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF83E0FB).withValues(alpha: 0.15),
                                                  blurRadius: 2,
                                                  spreadRadius: 0.5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Rectangle 4 (Blur: 6px, Opacity: 0.22, Border: 2px solid #83E0FB)
                                        Positioned.fill(
                                          child: Opacity(
                                            opacity: 0.22,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(9999),
                                                border: Border.all(
                                                  color: const Color(0xFF83E0FB),
                                                  width: 2,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xFF83E0FB),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Rectangle 5 (Blur: 6px, Opacity: 0.22, Border: 2px solid #4481DC)
                                        Positioned.fill(
                                          child: Opacity(
                                            opacity: 0.22,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(9999),
                                                border: Border.all(
                                                  color: const Color(0xFF4481DC),
                                                  width: 2,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xFF4481DC),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Frame 48096401 (The actual button container)
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const HomeScreen(),
                                                ),
                                              );
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
                                                    Color(0xFF3965DA), // #3965DA
                                                    Color(0xFF5EC8E2), // #5EC8E2
                                                  ],
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'splash.get_started'.tr(),
                                                style: GoogleFonts.getFont(
                                                  'Inter',
                                                  textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    height: 24.0 / 18.0, // 24px line height (133%)
                                                    letterSpacing: -0.36, // -0.02em (-2%)
                                                    color: Colors.white,
                                                  ),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
