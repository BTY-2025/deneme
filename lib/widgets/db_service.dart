import 'package:mysql1/mysql1.dart';
import 'package:flutter/foundation.dart';

class DbService {
  static ConnectionSettings get _settings => ConnectionSettings(
        host: '5.39.8.160',
        port: 3306,
        user: 'flywork1_pdfologyUser',
        password: 'YlNlO?xaZnCQ1CBA',
        db: 'flywork1_pdfology',
        timeout: const Duration(seconds: 10),
      );

  static Future<void> initializeTable() async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(_settings);
      
      await conn.query('''
        CREATE TABLE IF NOT EXISTS users (
          firebase_uid VARCHAR(128) PRIMARY KEY,
          is_premium BOOLEAN DEFAULT FALSE,
          last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
      ''');

      await conn.query('''
        CREATE TABLE IF NOT EXISTS user_uploads (
          id INT AUTO_INCREMENT PRIMARY KEY,
          firebase_uid VARCHAR(128) NOT NULL,
          file_name VARCHAR(255) NOT NULL,
          file_size BIGINT,
          uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
      ''');

      await conn.query('''
        CREATE TABLE IF NOT EXISTS user_actions (
          id INT AUTO_INCREMENT PRIMARY KEY,
          firebase_uid VARCHAR(128) NOT NULL,
          action_type VARCHAR(64) NOT NULL,
          details TEXT,
          performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
      ''');

      debugPrint("MySQL Database tables initialized successfully.");
    } catch (e) {
      debugPrint("Failed to initialize database tables: $e");
    } finally {
      await conn?.close();
    }
  }

  static Future<void> updateUserPremiumStatus(String firebaseUid, bool isPremium) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(_settings);
      await conn.query('''
        INSERT INTO users (firebase_uid, is_premium)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE is_premium = VALUES(is_premium)
      ''', [firebaseUid, isPremium]);
      debugPrint("Updated premium status for user: $firebaseUid to $isPremium");
    } catch (e) {
      debugPrint("Failed to update user status in DB: $e");
    } finally {
      await conn?.close();
    }
  }

  static Future<void> logFileUpload({
    required String firebaseUid,
    required String fileName,
    required int fileSize,
  }) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(_settings);
      
      await conn.query('''
        INSERT INTO users (firebase_uid, is_premium)
        VALUES (?, FALSE)
        ON DUPLICATE KEY UPDATE last_seen = CURRENT_TIMESTAMP
      ''', [firebaseUid]);

      await conn.query(
        'INSERT INTO user_uploads (firebase_uid, file_name, file_size) VALUES (?, ?, ?)',
        [firebaseUid, fileName, fileSize],
      );
      debugPrint("Logged file upload successfully: $fileName for user: $firebaseUid");
    } catch (e) {
      debugPrint("Failed to log file upload: $e");
    } finally {
      await conn?.close();
    }
  }

  static Future<void> logUserAction({
    required String firebaseUid,
    required String actionType,
    required String details,
  }) async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(_settings);
      
      await conn.query('''
        INSERT INTO users (firebase_uid, is_premium)
        VALUES (?, FALSE)
        ON DUPLICATE KEY UPDATE last_seen = CURRENT_TIMESTAMP
      ''', [firebaseUid]);

      await conn.query(
        'INSERT INTO user_actions (firebase_uid, action_type, details) VALUES (?, ?, ?)',
        [firebaseUid, actionType, details],
      );
      debugPrint("Logged action '$actionType' successfully for user: $firebaseUid");
    } catch (e) {
      debugPrint("Failed to log user action in DB: $e");
    } finally {
      await conn?.close();
    }
  }
}
