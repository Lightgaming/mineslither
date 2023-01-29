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
          Positioned.fill(
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
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(20),
                      ),
                    ),
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
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(20),
                      ),
                    ),
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
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(20),
                      ),
                    ),
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
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(20),
                      ),
                    ),
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Exit'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: PayPalButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(20),
                  ),
                ),
                onDonation: () {
                  print('Donation successful');
                  // Snack Bar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Thank you for showing interest into my work!'),
                    ),
                  );
                },
                paypalButtonId: "VYTU88VHK2QD4",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
