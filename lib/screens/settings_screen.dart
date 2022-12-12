import 'package:flutter/material.dart';
import 'package:mineslither/main.dart';
import 'package:mineslither/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController timerDurationController = TextEditingController();

  // init
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GameAppBar(),
      body: Column(
        children: [
          const Text('Settings'),
          // Timer Duration

          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            controller: timerDurationController,
          )
        ],
      ),
    );
  }
}
