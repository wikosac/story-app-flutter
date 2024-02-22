import 'package:go_router/go_router.dart';
import 'package:story_app/ui/home_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/register_page.dart';

export 'package:go_router/go_router.dart';

part 'route_name.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
      routes: [
        GoRoute(
          path: 'register',
          name: Routes.register,
          builder: (context, state) => const RegisterPage(),
        ),
      ]
    ),
    GoRoute(
      path: '/home',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
  errorBuilder: (context, state) { throw Exception('Error 404'); }
);