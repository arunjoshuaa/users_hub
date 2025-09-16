import 'package:go_router/go_router.dart';
import 'package:users_hub/features/auth/presentation/screens/login_screen.dart';
import 'package:users_hub/features/home/presentation/screens/home_screen.dart';
import 'package:users_hub/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:users_hub/features/no_network/presentation/screens/no_network_screen.dart';
import 'package:users_hub/features/profile/presentation/screens/profile_screen.dart';
import 'package:users_hub/features/settings/presentation/screens/settings_screen.dart';
import 'package:users_hub/features/users/presentation/screens/user_details_screen.dart';
import 'package:users_hub/main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => CustomBottomNavBar(),
    ),
    GoRoute(
      path: '/homepage',
      name: 'homepage',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/user/:id',
      name: 'userDetails',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailsScreen(userId: int.parse(userId));
      },
    ),
    GoRoute(
      path: '/nonetwork',
      name: 'nonetworkpage',
      builder: (context, state) => NoNetworkScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profilepage',
      builder: (context, state) => ProfilePage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settingspage',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
