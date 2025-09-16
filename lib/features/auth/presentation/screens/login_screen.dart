import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:toastification/toastification.dart';
import 'package:users_hub/core/utils/network_util.dart';
import 'package:users_hub/features/auth/presentation/providers/auth_provider.dart';
import 'package:users_hub/l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = AppLocalizations.of(context)!;
    final signInAsync = ref.watch(signInWithGoogleProvider);

    ref.listen(signInWithGoogleProvider, (_, state) {
      state.when(
        data: (user) {
          if (user != null) context.go('/home');
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign in failed: $error")),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              /// App Logo
              Hero(
                tag: "app_logo",
                child: Image.asset(
                  "assets/images/splash_logo.png",
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 32),

              /// Welcome
              Text(
                appLocalizations.welcomeToApp,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              /// Subtext
              Text(
                appLocalizations.signInWithGoogle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              /// Sign In Button or Loader
              signInAsync.isLoading
                  ? SizedBox(
                    width: double.infinity,
                    child: Center(child: const CircularProgressIndicator()))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: Text(appLocalizations.signInWithGoogle),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          final isOnline = await NetworkUtil.hasInternet();
                          if (!isOnline) {
                            Toastification().show(
                              context: context,
                              title: Text(appLocalizations.noNetworkConnection),
                              description: Text(
                                appLocalizations.checkInternetTryAgain,
                              ),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                            );
                            return;
                          }
                          ref.refresh(signInWithGoogleProvider.future);
                        },
                      ),
                    ),

              const Spacer(),

              /// Footer
              Text(
                "© ${DateTime.now().year} Users Hub",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
