// lib/services/token_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _tokenKey = 'auth_token';
  static const String _tokenTypeKey = 'token_type';

  // Store token
  static Future<void> storeToken(
    String token, {
    String tokenType = 'Bearer',
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _tokenTypeKey, value: tokenType);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get token type
  static Future<String?> getTokenType() async {
    return await _storage.read(key: _tokenTypeKey);
  }

  // Get full authorization header
  static Future<String?> getAuthorizationHeader() async {
    final token = await getToken();
    final tokenType = await getTokenType();

    if (token != null && tokenType != null) {
      return '$tokenType $token';
    }
    return null;
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear token (for logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenTypeKey);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> clearTokenForDevelopment() async {
    await _storage.deleteAll();
    print('Development: All tokens cleared');
  }
}
