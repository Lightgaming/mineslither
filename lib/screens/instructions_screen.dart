import 'package:flutter/material.dart';
import 'package:mineslither/widgets/app_bar.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GameAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Instructions', style: TextStyle(fontSize: 24.0)),
            // Instructions
            Text(
                'Combination of Snake and Mineweeper. Flagged/Correctly Found Bombs are converted into food for the snake. You win when all the bombs are found and all the food is eaten.')
          ],
        ),
      ),
    );
  }
}
