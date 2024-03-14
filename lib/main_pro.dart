import 'package:flutter/material.dart';
import 'package:story_app/main.dart';
import 'package:story_app/variant/flavor_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: FlavorType.pro,
    values: const FlavorValues(
      appType: "Pro",
    ),
  );
  runApp(const MainApp());
}

// flutter run -t lib/main_pro.dart