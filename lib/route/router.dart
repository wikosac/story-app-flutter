import 'package:go_router/go_router.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/register_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);