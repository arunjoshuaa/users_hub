import 'package:flutter/material.dart';
import 'package:users_hub/config/connectivity_service.dart';
import 'package:users_hub/l10n/app_localizations.dart';

class NoNetworkScreen extends StatefulWidget {
  final bool insideBottomNav;
  const NoNetworkScreen({super.key, this.insideBottomNav = false});

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  late final GlobalConnectivityService _connectivityService;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = GlobalConnectivityService();

    // Listen for connectivity changes
    _connectivityService.connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          this.isOnline = isOnline;
        });

        if (isOnline) {
          if (!widget.insideBottomNav) {
            Navigator.of(context).pop();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                appLocalizations.noInternetConnection,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                appLocalizations.checkInternetAutoResume,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(appLocalizations.retryNow),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final isOnline = await _connectivityService.checkConnection();
                  if (isOnline && mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
