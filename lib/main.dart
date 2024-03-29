import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/common/style.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/auth_preferences.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/picture_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/route/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => PictureProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoryProvider(
            apiService: ApiService(),
            preferences: AuthPreferences(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            preferences: AuthPreferences(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            theme: ThemeData(useMaterial3: true, colorScheme: lightTheme),
            darkTheme: ThemeData(useMaterial3: true, colorScheme: darkTheme),
            title: 'Story App',
            routerConfig: createRouter(context),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
