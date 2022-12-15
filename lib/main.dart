import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mineslither/config/app_config.dart';
import 'package:mineslither/config/app_theme.dart';
import 'package:mineslither/screens/game_screen.dart';
import 'package:mineslither/screens/instructions_screen.dart';
import 'package:mineslither/screens/main_menu_screen.dart';
import 'package:mineslither/screens/settings_screen.dart';

import 'firebase_options.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(),
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) => const GameScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/tutorial',
      builder: (context, state) => const InstructionsScreen(),
    ),
  ],
);

final storage = LocalStorage('settings');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // check if is windows then disable firebase
  if (!Platform.isWindows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // if (kDebugMode) {
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: _router,
    );
  }
}
