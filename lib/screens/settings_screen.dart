import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_settings.dart';
import 'package:mineslither/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool easyMode = false;

  @override
  Widget build(BuildContext context) {
    easyMode = AppSettings().getEasyMode();
    return Scaffold(
      appBar: const GameAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Easy Mode'),
                Switch(
                  value: easyMode,
                  onChanged: (val) {
                    val
                        ? AppSettings().setEasyModeTrue()
                        : AppSettings().setEasyModeFalse();
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
