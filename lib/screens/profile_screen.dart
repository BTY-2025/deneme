import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_back_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/user_manager.dart';
import '../widgets/auth_purchase_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild when language changes
    return Scaffold(
      backgroundColor: const Color(0xFF050E22),
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Positioned(
            left: -255,
            top: -149,
            width: 1004,
            height: 1103,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/image_3.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 61, sigmaY: 61),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      CustomBackButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'profile.profile'.tr(),
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Info
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF626262),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF626262),
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _showChangeNameBottomSheet(context),
                              child: Row(
                                children: [
                                  ValueListenableBuilder<String>(
                                    valueListenable: UserManager.userNameNotifier,
                                    builder: (context, userName, child) {
                                      return Text(
                                        userName,
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  SvgPicture.asset(
                                    'assets/images/rename.svg',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // "HESAP AYARLARI" Section
                        Text(
                          'profile.settings'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Settings List
                        _buildSettingItem(
                          title: 'profile.notifications'.tr(),
                          iconWidget: SvgPicture.asset(
                            'assets/images/zil.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          iconBgColor: const Color(0x1A57B4E0),
                          trailing: Switch(
                            value: true,
                            onChanged: (val) {},
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF57B4E0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildSettingItem(
                          title: 'profile.feedback'.tr(),
                          iconWidget: SvgPicture.asset(
                            'assets/images/feedback.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          iconBgColor: const Color(0x1A57B4E0),
                        ),
                        const SizedBox(height: 12),

                        ValueListenableBuilder<bool>(
                          valueListenable: AuthPurchaseService.isPremiumNotifier,
                          builder: (context, isPremium, child) {
                            return GestureDetector(
                              onTap: isPremium
                                  ? null
                                  : () async {
                                      await AuthPurchaseService.buyPremium();
                                    },
                              child: _buildSettingItem(
                                title: 'profile.premium'.tr(),
                                iconWidget: Image.asset(
                                  'assets/images/diamond.png',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                                iconBgColor: const Color(0x1ABB29FF),
                                customTrailing: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isPremium
                                            ? const Color(0x3334C759)
                                            : const Color(0x333965DA),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        isPremium ? 'profile.active'.tr() : 'profile.passive'.tr(),
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isPremium
                                                ? const Color(0xFF34C759)
                                                : const Color(0xFF57B4E0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (!isPremium)
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFFB8B8C7),
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _showShareAppBottomSheet(context),
                          child: _buildSettingItem(
                            title: 'profile.share_the_app'.tr(),
                            iconWidget: SvgPicture.asset(
                              'assets/images/shareprofile.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            iconBgColor: const Color(0x1A57B4E0),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildSettingItem(
                          title: 'profile.rate_us'.tr(),
                          iconWidget: SvgPicture.asset(
                            'assets/images/rateus.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          iconBgColor: const Color(0x1A57B4E0),
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _showFAQBottomSheet(context),
                          child: _buildSettingItem(
                            title: 'profile.faq'.tr(),
                            iconWidget: SvgPicture.asset(
                              'assets/images/faqicon.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            iconBgColor: const Color(0x1A57B4E0),
                          ),
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _showLanguageBottomSheet(context),
                          child: _buildSettingItem(
                            title: 'profile.language'.tr(),
                            iconWidget: SvgPicture.asset(
                              'assets/images/language.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            iconBgColor: const Color(0x1A57B4E0),
                          ),
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _showLogoutBottomSheet(context),
                          child: _buildSettingItem(
                            title: 'profile.logout'.tr(),
                            iconWidget: SvgPicture.asset(
                              'assets/images/cikis.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            iconBgColor: const Color(0x1AD90000),
                            hideChevron: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required Widget iconWidget,
    required Color iconBgColor,
    Widget? trailing,
    Widget? customTrailing,
    bool hideChevron = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2), // rgba(0, 0, 0, 0.2)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2), // rgba(255, 255, 255, 0.2)
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: iconWidget,
              ),
              const SizedBox(width: 12),
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
            ],
          ),
          if (customTrailing != null)
            customTrailing
          else if (trailing != null)
            trailing
          else if (!hideChevron)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFB8B8C7),
              size: 20,
            ),
        ],
      ),
    );
  }

  void _showChangeNameBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: UserManager.userNameNotifier.value,
    );
    _showBlurredBottomSheet(
      context,
      (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Header (Change Name & Close Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'profile.change_name'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB8B8C7), width: 2),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFB8B8C7),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Text Field Container
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: nameController,
                    style: GoogleFonts.getFont(
                      'Inter',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    decoration: InputDecoration(
                      hintText: 'profile.update_name'.tr(),
                      hintStyle: GoogleFonts.getFont(
                        'Inter',
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Save Button
                GestureDetector(
                  onTap: () {
                    UserManager.updateName(nameController.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'common.save'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareAppBottomSheet(BuildContext context) {
    _showBlurredBottomSheet(
      context,
      (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Header (Share the App & Close Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'profile.share_the_app'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB8B8C7), width: 2),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFB8B8C7),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Link Container
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.link,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'https://apps.apple.com/tr/app/sunum_olusturma/share...',
                          style: GoogleFonts.getFont(
                            'Urbanist',
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Share Button
                GestureDetector(
                  onTap: () {
                    // Logic to share
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'common.share'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFAQBottomSheet(BuildContext context) {
    int expandedIndex = 0;
    final List<Map<String, String>> faqs = [
      {
        'q': 'faq.q1'.tr(context: context),
        'a': 'faq.a1'.tr(context: context)
      },
      {
        'q': 'faq.q2'.tr(context: context),
        'a': 'faq.a2'.tr(context: context)
      },
      {
        'q': 'faq.q3'.tr(context: context),
        'a': 'faq.a3'.tr(context: context)
      },
    ];

    _showBlurredBottomSheet(
      context,
      (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 55,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'profile.faq'.tr(),
                          style: GoogleFonts.getFont(
                            'Inter',
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFB8B8C7), width: 2),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFFB8B8C7),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // FAQ Items
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(faqs.length, (index) {
                            final faq = faqs[index];
                            final isExpanded = expandedIndex == index;
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedIndex = isExpanded ? -1 : index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isExpanded 
                                      ? const Color(0xFF57B4E0).withValues(alpha: 0.05) 
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isExpanded 
                                        ? const Color(0xFF57B4E0) 
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            faq['q']!,
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: isExpanded 
                                                    ? const Color(0xFF57B4E0) 
                                                    : Colors.white.withValues(alpha: 0.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: isExpanded 
                                              ? const Color(0xFF57B4E0) 
                                              : Colors.white.withValues(alpha: 0.7),
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    if (isExpanded) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        faq['a']!,
                                        style: GoogleFonts.getFont(
                                          'Inter',
                                          textStyle: TextStyle(
                                            fontSize: 13,
                                            height: 1.5,
                                            color: Colors.white.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final String currentLangCode = context.locale.languageCode;
    String selectedLanguage = 'İngilizce';
    switch (currentLangCode) {
      case 'tr': selectedLanguage = 'Türkçe'; break;
      case 'en': selectedLanguage = 'İngilizce'; break;
      case 'de': selectedLanguage = 'Almanca'; break;
      case 'it': selectedLanguage = 'İtalyanca'; break;
      case 'fr': selectedLanguage = 'Fransızca'; break;
      case 'ja': selectedLanguage = 'Japonca'; break;
      case 'es': selectedLanguage = 'İspanyolca'; break;
      case 'ru': selectedLanguage = 'Rusça'; break;
      case 'ko': selectedLanguage = 'Korece'; break;
      case 'hi': selectedLanguage = 'Hintçe'; break;
      case 'pt': selectedLanguage = 'Portekizce'; break;
      case 'zh': selectedLanguage = 'Çince'; break;
    }

    final List<String> languages = [
      'Türkçe',
      'İngilizce',
      'Almanca',
      'İtalyanca',
      'Fransızca',
      'Japonca',
      'İspanyolca',
      'Rusça',
      'Korece',
      'Hintçe',
      'Portekizce',
      'Çince',
    ];
    _showBlurredBottomSheet(
      context,
      (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 55,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'profile.language'.tr(),
                            style: GoogleFonts.getFont(
                              'Inter',
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFB8B8C7), width: 2),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFFB8B8C7),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                  
                      // List of languages
                      ...languages.map((lang) {
                        final isSelected = selectedLanguage == lang;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedLanguage = lang;
                              });
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF57B4E0).withValues(alpha: 0.1) 
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected 
                                      ? const Color(0xFF57B4E0) 
                                      : Colors.white.withValues(alpha: 0.2),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _buildFlag(lang),
                                  const SizedBox(width: 10),
                                  Text(
                                    lang,
                                    style: GoogleFonts.getFont(
                                      'Inter',
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected 
                                            ? const Color(0xFF57B4E0) 
                                            : Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      
                      // Save Button
                      GestureDetector(
                        onTap: () async {
                          Locale newLocale = const Locale('en');
                          switch (selectedLanguage) {
                            case 'Türkçe': newLocale = const Locale('tr'); break;
                            case 'İngilizce': newLocale = const Locale('en'); break;
                            case 'Almanca': newLocale = const Locale('de'); break;
                            case 'İtalyanca': newLocale = const Locale('it'); break;
                            case 'Fransızca': newLocale = const Locale('fr'); break;
                            case 'Japonca': newLocale = const Locale('ja'); break;
                            case 'İspanyolca': newLocale = const Locale('es'); break;
                            case 'Rusça': newLocale = const Locale('ru'); break;
                            case 'Korece': newLocale = const Locale('ko'); break;
                            case 'Hintçe': newLocale = const Locale('hi'); break;
                            case 'Portekizce': newLocale = const Locale('pt'); break;
                            case 'Çince': newLocale = const Locale('zh'); break;
                          }
                          await context.setLocale(newLocale);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'common.save'.tr(),
                            style: GoogleFonts.getFont(
                              'Inter',
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    _showBlurredBottomSheet(
      context,
      (BuildContext context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'profile.logout'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB8B8C7), width: 2),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFB8B8C7),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Content text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'profile.logout_confirm'.tr(),
                    style: GoogleFonts.getFont(
                      'Inter',
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'profile.cancel'.tr(),
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBlurredBottomSheet(BuildContext context, WidgetBuilder builder) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              FadeTransition(
                opacity: animation,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(color: Colors.black.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: builder(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlag(String language) {
    return Container(
      width: 28,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: _getFlagContent(language),
    );
  }

  Widget _getFlagContent(String language) {
    String code = 'tr';
    switch (language) {
      case 'Türkçe': code = 'tr'; break;
      case 'İngilizce': code = 'gb'; break;
      case 'Almanca': code = 'de'; break;
      case 'İtalyanca': code = 'it'; break;
      case 'Fransızca': code = 'fr'; break;
      case 'Japonca': code = 'jp'; break;
      case 'İspanyolca': code = 'es'; break;
      case 'Rusça': code = 'ru'; break;
      case 'Korece': code = 'kr'; break;
      case 'Hintçe': code = 'in'; break;
      case 'Portekizce': code = 'pt'; break;
      case 'Çince': code = 'cn'; break;
    }
    
    return Image.network(
      'https://flagcdn.com/w40/$code.png',
      width: 28,
      height: 20,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
    );
  }
}
