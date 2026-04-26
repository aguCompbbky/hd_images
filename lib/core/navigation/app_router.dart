import 'package:go_router/go_router.dart';
import 'package:hd_images/features/auth/presentation/pages/login_page.dart';
import 'package:hd_images/features/auth/presentation/pages/register_page.dart';
import 'package:hd_images/features/settings/presentation/pages/settings_page.dart';
import 'package:hd_images/features/upscale/presentation/pages/home_page.dart';

class AppRouter {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home'; 
  static const String settingsRoute = '/settings'; 
  
  static final GoRouter router = GoRouter(
    initialLocation: loginRoute,
    routes: [
      GoRoute(
        path: loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: homeRoute,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: settingsRoute,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
