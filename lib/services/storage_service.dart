import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/logger.dart';
class StorageService {
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: tokenKey, value: token);
    } catch (e) {
      AppLogger.error('Error saving token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: tokenKey);
    } catch (e) {
      AppLogger.error('Error getting token: $e');
      return null;
    }
  }

  Future<void> saveUserEmail(String email) async {
    try {
      await _storage.write(key: userEmailKey, value: email);
    } catch (e) {
      AppLogger.error('Error saving user email: $e');
    }
  }

  Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: userEmailKey);
    } catch (e) {
      AppLogger.error('Error getting user email: $e');
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      AppLogger.error('Error clearing storage: $e');
    }
  }
}

