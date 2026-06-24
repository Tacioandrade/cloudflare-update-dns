import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyAuth = 'authenticated';
  static const String _keyToken = 'cf_api_token';
  static const String _keyAppPassword = 'app_password';
  static const String _keyDnsTypes = 'dns_types';

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAuth) ?? false;
  }

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuth, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuth);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getAppPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppPassword);
  }

  static Future<bool> hasAppPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString(_keyAppPassword);
    return password != null && password.isNotEmpty;
  }

  static Future<void> saveAppPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppPassword, password);
  }

  static Future<List<String>> getDnsTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyDnsTypes) ?? ['A', 'CNAME'];
  }

  static Future<void> saveDnsTypes(List<String> types) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyDnsTypes, types);
  }
}
