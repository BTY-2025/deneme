import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final ValueNotifier<String> userNameNotifier = ValueNotifier<String>('User0123374123');

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');
      if (savedName != null && savedName.isNotEmpty) {
        userNameNotifier.value = savedName;
      }
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  static Future<void> updateName(String name) async {
    if (name.trim().isEmpty) return;
    userNameNotifier.value = name.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name.trim());
    } catch (e) {
      debugPrint('Error saving username: $e');
    }
  }
}
