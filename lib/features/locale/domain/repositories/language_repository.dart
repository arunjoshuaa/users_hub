import 'package:flutter/material.dart';

abstract class LanguageRepository {
  Future<Locale?> getLanguage();
  Future<void> saveLanguage(Locale locale);
}
