import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final SharedPreferences prefs;

  LanguageRepositoryImpl(this.prefs);

  static const String _languageCodeKey = 'languageCode';

  @override
  Future<Locale?> getLanguage() async {
    final langCode = prefs.getString(_languageCodeKey);
    return langCode != null ? Locale(langCode) : null;
  }

  @override
  Future<void> saveLanguage(Locale locale) async {
    await prefs.setString(_languageCodeKey, locale.languageCode);
  }
}
