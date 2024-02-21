import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/route/router.dart';

void main() {
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
        )
      ],
      child: MaterialApp.router(
        title: 'Story App',
        routerConfig: router,
      ),
    );
  }
}
