import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_donation_buttons/flutter_donation_buttons.dart';
import 'package:go_router/go_router.dart';
import 'package:mineslither/widgets/app_bar.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GameAppBar(),
      body: Stack(
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go('/play');
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go('/tutorial');
                    },
                    icon: const Icon(Icons.help),
                    label: const Text('Instructions'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go('/settings');
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Exit app
                      SystemNavigator.pop();
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Exit'),
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: PayPalButton(
                paypalButtonId: "VYTU88VHK2QD4",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
