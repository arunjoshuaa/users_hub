import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:users_hub/config/connectivity_service.dart'; // your service
import 'package:users_hub/config/notification_service.dart';
import 'package:users_hub/features/home/presentation/screens/home_screen.dart';
import 'package:users_hub/features/no_network/presentation/screens/no_network_screen.dart';
import 'package:users_hub/features/profile/presentation/screens/profile_screen.dart';
import 'package:users_hub/features/settings/presentation/screens/settings_screen.dart';
import 'package:users_hub/l10n/app_localizations.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().initNotifications(context);
  }
  final List<Widget> _pages = const [
    HomeScreen(),
    ProfilePage(),
    SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
             final appLocalizations = AppLocalizations.of(context)!;  // Access localization here

    return StreamBuilder<bool>(
      stream: GlobalConnectivityService().connectivityStream,
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;

  //       // Allow Profile page (index 1) to work offline
  //       if (!isOnline && _currentIndex != 1) {
  //  WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     // Navigate safely after build
  //     context.push  ('/nonetwork'); // or Navigator.pushReplacementNamed
  //   });
  // }
         // return NoNetworkScreen();
         // context.go('/nonetwork');
     //   }

        return Scaffold(
          body: _currentIndex == 1 // Profile index
      ? _pages[_currentIndex] // Always show Profile
      : isOnline
          ? _pages[_currentIndex] // Online: show normal page
          : NoNetworkScreen(insideBottomNav: true),    // Offline: show NoNetworkScreen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: appLocalizations.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: appLocalizations.profile,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: appLocalizations.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
