import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mineslither/widgets/app_bar.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GameAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/play');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.pushNamed(context, '/play');
                },
                icon: const Icon(Icons.scoreboard),
                label: const Text('Scoreboard'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.pushNamed(context, '/play');
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
    );
  }
}
