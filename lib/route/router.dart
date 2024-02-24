import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/navigation.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/ui/home_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/register_page.dart';

export 'package:go_router/go_router.dart';

part 'route_name.dart';

GoRouter createRouter(BuildContext context) {
  AuthProvider authProvider = Provider.of(context, listen: false);
  String initial = authProvider.token.isEmpty ? '/login' : '/navigation';

  return GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
          path: '/login',
          name: Routes.login,
          builder: (context, state) => LoginPage(),
          routes: [
            GoRoute(
              path: 'register',
              name: Routes.register,
              builder: (context, state) => RegisterPage(),
            ),
          ]),
      GoRoute(
        path: '/navigation',
        name: Routes.navigation,
        builder: (context, state) => const Navigation(),
      ),
    ],
    errorBuilder: (context, state) {
      throw Exception('Error 404');
    },
    refreshListenable: authProvider,
    routerNeglect: true,
  );
}
