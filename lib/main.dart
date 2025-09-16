import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_hub/config/app_router.dart';
import 'package:users_hub/config/app_theme.dart';
import 'package:users_hub/config/connectivity_service.dart';
import 'package:users_hub/features/locale/presentation/providers/locale_provider.dart';
import 'package:users_hub/features/profile/presentation/providers/profile_providers.dart';
import 'package:users_hub/features/theme/presentation/providers/theme_provider.dart';
import 'package:users_hub/firebase_options.dart';
import 'package:users_hub/l10n/app_localizations.dart';

/// 🔔 Handle background FCM messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("🔔 Handling background message: ${message.messageId}");
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
 final prefs = await SharedPreferences.getInstance();
  // 🌐 Start connectivity monitoring
  GlobalConnectivityService().startMonitoring();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 Listen for background FCM messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp( ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(AsyncValue.data(prefs)), // ✅ Correct

    ],
    child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = localeAsync.when(
      data: (locale) => locale ?? const Locale('en'),
      loading: () => const Locale('en'),
      error: (_, __) => const Locale('en'),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Users Hub",
      routerConfig: router,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // 🌍 Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.lightTheme,

   
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      final container = ProviderScope.containerOf(context, listen: false);
      final profileRepo = container.read(profileRepositoryProvider);

      final user = await profileRepo.getProfile();

      if (user != null) {
        debugPrint("✅ User found locally: ${user.name}, ${user.email}");
        context.go('/home');
      } else {
        debugPrint("❌ No user found locally.");
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF12A0C7), Color(0xFF0A6C8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "app_logo",
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  height: 160,
                  width: 160,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
