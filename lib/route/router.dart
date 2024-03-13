import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/navigation.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/ui/detail_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/maps_page.dart';
import 'package:story_app/ui/picker_map_page.dart';
import 'package:story_app/ui/register_page.dart';
import 'package:story_app/ui/upload_page.dart';
import 'package:story_app/utils/custom_dialog.dart';

export 'package:go_router/go_router.dart';

part 'route_name.dart';

GoRouter createRouter(BuildContext context) {
  AuthProvider authProvider = Provider.of(context, listen: false);
  String initial =
      authProvider.token == null || authProvider.token?.isEmpty == true
          ? '/login'
          : '/navigation';

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
        ],
      ),
      GoRoute(
        path: '/navigation',
        name: Routes.navigation,
        builder: (context, state) => const Navigation(),
        routes: [
          GoRoute(
            path: 'dialog',
            name: Routes.dialog,
            builder: (context, state) => const CustomDialog(),
          ),
          GoRoute(
            path: 'upload',
            name: Routes.upload,
            builder: (context, state) => const UploadPage(),
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const UploadPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child,
                );
              },
            ),
            routes: [
              GoRoute(
                path: 'picker',
                name: Routes.mapPicker,
                builder: (context, state) => const PickerScreen(),
              ),
            ]
          ),
          GoRoute(
            path: ':id',
            name: Routes.detail,
            builder: (context, state) =>
                DetailPage(id: state.pathParameters['id']!),
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: DetailPage(id: state.pathParameters['id']!),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(animation),
                    child: child,
                  );
                },),
            routes: [
              GoRoute(
                path: 'map',
                name: Routes.map,
                builder: (context, state) => const MapsPage(),
              ),
            ]
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      throw Exception('Error 404');
    },
    refreshListenable: authProvider,
    routerNeglect: true,
  );
}
