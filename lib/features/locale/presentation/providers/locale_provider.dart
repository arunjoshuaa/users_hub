import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_hub/features/locale/data/repositories/repository_impl.dart';
import 'package:users_hub/l10n/app_localizations.dart';

final contextProvider = Provider<BuildContext>((ref) {
  throw UnimplementedError('App context is not yet available.');
});


final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  // No need to use BuildContext, directly access AppLocalizations in the widget
  throw UnimplementedError('AppLocalizations provider should not be used directly.');
});


final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final languageRepositoryProvider = Provider<LanguageRepositoryImpl>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);  // Using watch to ensure it's resolved
  return prefs.when(
    data: (prefs) => LanguageRepositoryImpl(prefs),  // Once data is available, return the repository
    loading: () => throw UnimplementedError('SharedPreferences are loading'),  // Handle loading state
    error: (error, stack) => throw Exception('Error loading SharedPreferences: $error'),  // Handle error state
  );
});

class LocaleNotifier extends StateNotifier<AsyncValue<Locale?>> {
  final LanguageRepositoryImpl _languageRepository;

  LocaleNotifier(this._languageRepository) : super(const AsyncValue.loading()) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      // Attempt to load the locale from the repository
      final locale = await _languageRepository.getLanguage();
      state = AsyncValue.data(locale);
    } catch (e) {
      // If there's an error, update state with error and current stack trace
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setLocale(Locale locale) async {
    // Check if state is AsyncData and the current data is different from the new locale
    state.whenData((currentLocale) {
      if (currentLocale != locale) {
        state = const AsyncValue.loading();
        _languageRepository.saveLanguage(locale);  // Save new locale
        state = AsyncValue.data(locale);           // Update with the new locale
      }
    });
  }
}



final localeProvider = StateNotifierProvider<LocaleNotifier, AsyncValue<Locale?>>((ref) {
  final languageRepository = ref.watch(languageRepositoryProvider);

  return LocaleNotifier(languageRepository);
});

