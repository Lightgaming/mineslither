import 'package:flutter/material.dart';
import 'package:mineslither/config/app_config.dart';
import 'package:mineslither/config/app_theme.dart';
import 'package:mineslither/screens/game_screen.dart';
import 'package:mineslither/screens/main_menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/play': (context) => const GameScreen(),
      },
    );
  }
}
