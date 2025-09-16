import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:users_hub/features/locale/presentation/providers/locale_provider.dart';
import 'package:users_hub/features/theme/presentation/providers/theme_provider.dart';
import 'package:users_hub/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeProvider.notifier);
    final localeAsync = ref.watch(localeProvider); 
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: localeAsync.when(
          data: (currentLocale) {
            return ListView(
              children: [
                /// Language Section
                Text(
                  appLocalizations.changeLanguage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      RadioListTile<Locale>(
                        title: Row(
                          children: [
                            const Icon(Icons.language, color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(appLocalizations.languageEnglish),
                          ],
                        ),
                        value: const Locale('en'),
                        groupValue: currentLocale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            localeNotifier.setLocale(value);
                          }
                        },
                      ),
                      const Divider(height: 0),
                      RadioListTile<Locale>(
                        title: Row(
                          children: [
                            const Icon(Icons.translate, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(appLocalizations.languageHindi),
                          ],
                        ),
                        value: const Locale('hi'),
                        groupValue: currentLocale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            localeNotifier.setLocale(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Theme Section
                Text(
                  appLocalizations.changeTheme, // Add key in l10n
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children:  [
                            Icon(Icons.wb_sunny, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(appLocalizations.light),
                          ],
                        ),
                        value: ThemeMode.light,
                        groupValue: themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) themeNotifier.state = value;
                        },
                      ),
                      const Divider(height: 0),
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children:  [
                            Icon(Icons.nightlight_round, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text(appLocalizations.dark),
                          ],
                        ),
                        value: ThemeMode.dark,
                        groupValue: themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) themeNotifier.state = value;
                        },
                      ),
                      const Divider(height: 0),
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children:  [
                            Icon(Icons.brightness_auto, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Text(appLocalizations.systemDefault),
                          ],
                        ),
                        value: ThemeMode.system,
                        groupValue: themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) themeNotifier.state = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appLocalizations.retry),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                  label: Text(appLocalizations.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
