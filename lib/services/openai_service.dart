import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OpenAiService {
  static const String _apiKey = 'YOUR_API_KEY';

  static Future<String> extractTextFromPdf(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final rawString = String.fromCharCodes(bytes);
        final matches = RegExp(r'\(([^)]+)\)\s*(?:Tj|TJ)').allMatches(rawString);
        String extractedText = matches.map((m) => m.group(1) ?? '').join(' ');
        extractedText = extractedText
            .replaceAll(r'\(', '(')
            .replaceAll(r'\)', ')')
            .replaceAll(r'\r', '\n')
            .replaceAll(r'\n', '\n')
            .trim();
        return extractedText;
      }
    } catch (e) {
      debugPrint('Error extracting PDF text: $e');
    }
    return "";
  }

  static Future<Map<String, dynamic>> getSummary(String pdfText, String fileName) async {
    if (pdfText.isEmpty) {
      pdfText = "No readable text content found in $fileName.";
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'response_format': {'type': 'json_object'},
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert PDF summarizer. Output a JSON object with: '
                  '"summary" (a concise 1-2 paragraph description summarizing the document) '
                  'and "highlights" (an array of exactly 3 bullet points showing key insights). '
                  'Response language must match the language of the source text.'
            },
            {
              'role': 'user',
              'content': 'Here is the PDF text:\n\n$pdfText'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        final parsedJson = jsonDecode(content) as Map<String, dynamic>;
        return {
          'summary': parsedJson['summary'] ?? '',
          'highlights': List<String>.from(parsedJson['highlights'] ?? []),
        };
      } else {
        debugPrint('OpenAI error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching summary: $e');
    }

    // Fallback if API fails
    return {
      'summary': "This document was processed but the summary could not be retrieved from OpenAI. Original file: $fileName.",
      'highlights': [
        "Unloading/processing error",
        "Please check your internet connection",
        "Make sure the API key is active"
      ]
    };
  }

  static Future<String> chatWithPdf(String pdfText, List<Map<String, String>> chatHistory, String userMessage) async {
    try {
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': 'You are an AI assistant helping a user query a PDF document. '
              'Use the following extracted content of the PDF to answer the user\'s question accurately. '
              'Keep answers concise and informative.\n\nExtracted content:\n$pdfText'
        }
      ];

      // Add chat history
      for (final msg in chatHistory) {
        messages.add({
          'role': msg['isBot'] == 'true' ? 'assistant' : 'user',
          'content': msg['text'] ?? '',
        });
      }

      // Add user message
      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content']?.trim() ?? '';
      } else {
        debugPrint('OpenAI chat error: ${response.statusCode} ${response.body}');
        return "Error from OpenAI API: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint('Error chatting with PDF: $e');
      return "Could not connect to AI service: $e";
    }
  }
}
