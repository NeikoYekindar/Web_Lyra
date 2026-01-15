import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    print('🔄 Locale changed: ${_locale.languageCode} → ${locale.languageCode}');
    if (_locale.languageCode != locale.languageCode) {
      _locale = locale;
      notifyListeners();
      print('✅ notifyListeners() called');
    }
  }
}