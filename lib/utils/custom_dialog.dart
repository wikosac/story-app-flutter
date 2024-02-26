import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/utils.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.logoutDescription),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.goNamed(Routes.navigation),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return TextButton(
                onPressed: () {
                  auth.deleteCredential();
                  context.goNamed(Routes.login);
                  showSnackBar(context, AppLocalizations.of(context)!.loggedOut);
                },
                child: Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
