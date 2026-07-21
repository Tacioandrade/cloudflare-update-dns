import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyAuth = 'authenticated';
  static const String _keyToken = 'cf_api_token';
  static const String _keyAppPasswordHash = 'app_password_hash';
  static const String _keyDnsTypes = 'dns_types';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyUpdateCheckEnabled = 'update_check_enabled';
  static const String _keyLastUpdateCheckDate = 'last_update_check_date';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _passwordHashAlgorithm = 'pbkdf2_sha256';
  static const int _passwordHashIterations = 210000;
  static const int _passwordSaltLength = 16;
  static const int _passwordHashLength = 32;
  static bool _authenticatedInCurrentSession = false;

  static Future<bool> isAuthenticated() async {
    return _authenticatedInCurrentSession;
  }

  static Future<void> login() async {
    _authenticatedInCurrentSession = true;
  }

  static Future<void> logout() async {
    _authenticatedInCurrentSession = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuth);
  }

  static Future<String?> getToken() async {
    return _secureStorage.read(key: _keyToken);
  }

  static Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      await _secureStorage.delete(key: _keyToken);
      return;
    }
    await _secureStorage.write(key: _keyToken, value: token);
  }

  static Future<bool> verifyAppPassword(String password) async {
    final storedHash = await _secureStorage.read(key: _keyAppPasswordHash);
    if (storedHash == null || storedHash.isEmpty) {
      return false;
    }
    return _verifyPasswordHash(password, storedHash);
  }

  static Future<bool> hasAppPassword() async {
    final passwordHash = await _secureStorage.read(key: _keyAppPasswordHash);
    return passwordHash != null && passwordHash.isNotEmpty;
  }

  static Future<void> saveAppPassword(String password) async {
    final passwordHash = _hashPassword(password);
    await _secureStorage.write(key: _keyAppPasswordHash, value: passwordHash);
  }

  static Future<List<String>> getDnsTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyDnsTypes) ?? ['A', 'CNAME'];
  }

  static Future<void> saveDnsTypes(List<String> types) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyDnsTypes, types);
  }

  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  static Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, themeMode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'system';
  }

  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
  }

  static Future<bool> getUpdateCheckEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUpdateCheckEnabled) ?? true;
  }

  static Future<void> saveUpdateCheckEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUpdateCheckEnabled, enabled);
  }

  static Future<String?> getLastUpdateCheckDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastUpdateCheckDate);
  }

  static Future<void> saveLastUpdateCheckDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastUpdateCheckDate, date);
  }

  static String _hashPassword(String password) {
    final salt = _randomBytes(_passwordSaltLength);
    final hash = _pbkdf2(
      password: password,
      salt: salt,
      iterations: _passwordHashIterations,
      length: _passwordHashLength,
    );
    return [
      _passwordHashAlgorithm,
      _passwordHashIterations.toString(),
      base64Encode(salt),
      base64Encode(hash),
    ].join(r'$');
  }

  static bool _verifyPasswordHash(String password, String storedHash) {
    final parts = storedHash.split(r'$');
    if (parts.length != 4 || parts[0] != _passwordHashAlgorithm) {
      return false;
    }

    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) {
      return false;
    }

    try {
      final salt = base64Decode(parts[2]);
      final expectedHash = base64Decode(parts[3]);
      final actualHash = _pbkdf2(
        password: password,
        salt: salt,
        iterations: iterations,
        length: expectedHash.length,
      );
      return _constantTimeEquals(actualHash, expectedHash);
    } on FormatException {
      return false;
    }
  }

  static Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  static List<int> _pbkdf2({
    required String password,
    required List<int> salt,
    required int iterations,
    required int length,
  }) {
    const digestLength = 32;
    final hmac = Hmac(sha256, utf8.encode(password));
    final blockCount = (length / digestLength).ceil();
    final derivedKey = <int>[];

    for (var blockIndex = 1; blockIndex <= blockCount; blockIndex++) {
      final blockSalt = Uint8List(salt.length + 4)..setAll(0, salt);
      blockSalt.buffer.asByteData().setUint32(salt.length, blockIndex);

      var u = hmac.convert(blockSalt).bytes;
      final block = List<int>.from(u);

      for (var iteration = 1; iteration < iterations; iteration++) {
        u = hmac.convert(u).bytes;
        for (var i = 0; i < block.length; i++) {
          block[i] ^= u[i];
        }
      }

      derivedKey.addAll(block);
    }

    return derivedKey.take(length).toList();
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    var difference = a.length ^ b.length;
    final maxLength = max(a.length, b.length);

    for (var i = 0; i < maxLength; i++) {
      final aValue = i < a.length ? a[i] : 0;
      final bValue = i < b.length ? b[i] : 0;
      difference |= aValue ^ bValue;
    }

    return difference == 0;
  }
}
