import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:users_hub/config/connectivity_service.dart';
import 'package:users_hub/features/no_network/presentation/screens/no_network_screen.dart';

class ConnectivityWatcher extends StatefulWidget {
  final Widget child;
  const ConnectivityWatcher({super.key, required this.child});

  @override
  State<ConnectivityWatcher> createState() => _ConnectivityWatcherState();
}

class _ConnectivityWatcherState extends State<ConnectivityWatcher> {
  late final GlobalConnectivityService _connectivityService;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = GlobalConnectivityService();

    _connectivityService.connectivityStream.listen((isOnline) {
      if (!mounted) return;
      if (!isOnline && !_navigated) {
        _navigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
     context.push('/nonetwork');
          }
        });

      }else if (isOnline) {
    // Reset so next offline event will trigger again
    _navigated = false;

    // If you want to auto-pop when back online:
   
  }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
