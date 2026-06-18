import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_back_button.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/openai_service.dart';
import '../widgets/auth_purchase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdfaireader/widgets/db_service.dart';

class ChatMessage {
  final String text;
  final bool isBot;
  final String time;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.time,
  });
}

class PdfActiveChatScreen extends StatefulWidget {
  final String fileName;
  final String fileMeta;
  final String? filePath;

  const PdfActiveChatScreen({
    super.key,
    required this.fileName,
    required this.fileMeta,
    this.filePath,
  });

  @override
  State<PdfActiveChatScreen> createState() => _PdfActiveChatScreenState();
}

class _PdfActiveChatScreenState extends State<PdfActiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  String _pdfText = "";

  @override
  void initState() {
    super.initState();
    // Initialize with greeting message
    _messages.add(
      ChatMessage(
        text: 'chat.chat_greeting'.tr(args: [widget.fileName]),
        isBot: true,
        time: '09:41',
      ),
    );
    _loadPdfText();
  }

  Future<void> _loadPdfText() async {
    if (widget.filePath != null) {
      final text = await OpenAiService.extractTextFromPdf(widget.filePath!);
      if (mounted) {
        setState(() {
          _pdfText = text;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final isPremium = AuthPurchaseService.isPremiumNotifier.value;
    final userMessageCount = _messages.where((m) => !m.isBot).length;

    if (!isPremium && userMessageCount >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('chat.premium_limit_reached'.tr()),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      await AuthPurchaseService.buyPremium();
      return;
    }

    final text = _messageController.text.trim();
    if (text.isEmpty) return;
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DbService.logUserAction(
            firebaseUid: currentUser.uid,
            actionType: 'chat_message',
            details: widget.fileName,
          );
        }
        final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isBot: false,
          time: timeString,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final history = _messages.map((m) => {
        'isBot': m.isBot.toString(),
        'text': m.text,
      }).toList();
      if (history.isNotEmpty) history.removeLast();

      final responseText = await OpenAiService.chatWithPdf(_pdfText, history, text);

      if (!mounted) return;
      final replyTime = DateTime.now();
      final replyTimeString = '${replyTime.hour.toString().padLeft(2, '0')}:${replyTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        _messages.add(
          ChatMessage(
            text: responseText,
            isBot: true,
            time: replyTimeString,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      final replyTime = DateTime.now();
      final replyTimeString = '${replyTime.hour.toString().padLeft(2, '0')}:${replyTime.minute.toString().padLeft(2, '0')}';

      setState(() {
        _messages.add(
          ChatMessage(
            text: "Error: $e",
            isBot: true,
            time: replyTimeString,
          ),
        );
      });
      _scrollToBottom();
    }
  }

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
              children: [
                // Header (Frame 96)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      CustomBackButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      
                      // PDF Icon (Rectangle 9)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pdfimoji.png',
                          width: 40,
                          height: 42,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'tools.chat_with_pdf'.tr(),
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              widget.fileName,
                              style: GoogleFonts.getFont(
                                'Inter',
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
                                  color: Colors.white.withValues(alpha: 0.65),
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

                // Chat Messages Area
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: msg.isBot
                            ? _buildBotMessage(msg)
                            : _buildUserMessage(msg),
                      );
                    },
                  ),
                ),

                // Bottom Input Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.5, 8, 20.5, 24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.fromLTRB(16, 3, 8, 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: GoogleFonts.getFont(
                              'Inter',
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            decoration: InputDecoration(
                              hintText: 'chat.type_message'.tr(),
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
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3965DA),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 18,
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
    );
  }

  Widget _buildBotMessage(ChatMessage msg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Avatar
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3965DA),
                    Color(0xFF5EC8E2),
                  ],
                ),
                border: Border.all(
                  color: const Color(0x7083E0FB), // ~0.44 alpha
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            
            // Bot Message Bubble
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0x1A3965DA), // rgba(57, 101, 218, 0.1)
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: const Color(0x803965DA), // rgba(57, 101, 218, 0.5)
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.text,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        msg.time,
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 36), // Padding on right
          ],
        ),
      ],
    );
  }

  Widget _buildUserMessage(ChatMessage msg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 46), // Padding on left
            
            // User Message Bubble
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2), // rgba(0, 0, 0, 0.2)
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2), // rgba(255, 255, 255, 0.2)
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.text,
                      style: GoogleFonts.getFont(
                        'Inter',
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        msg.time,
                        style: GoogleFonts.getFont(
                          'Inter',
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
