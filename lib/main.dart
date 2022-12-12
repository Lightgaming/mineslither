import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mineslither/config/app_config.dart';
import 'package:mineslither/config/app_theme.dart';
import 'package:mineslither/screens/game_screen.dart';
import 'package:mineslither/screens/instructions_screen.dart';
import 'package:mineslither/screens/main_menu_screen.dart';
import 'package:mineslither/screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

final storage = LocalStorage('settings');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (kDebugMode) {
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // }

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
        '/settings': (context) => const SettingsScreen(),
        '/tutorial': (context) => const InstructionsScreen(),
      },
    );
  }
}
