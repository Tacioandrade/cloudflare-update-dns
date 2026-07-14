import 'package:flutter/material.dart';

class AppLanguageController {
  static const systemValue = 'system';
  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  static Locale? fromStorageValue(String value) {
    if (value == systemValue) return null;
    const supportedCodes = {'pt', 'en', 'fr', 'es', 'zh', 'ja'};
    return supportedCodes.contains(value) ? Locale(value) : null;
  }
}
