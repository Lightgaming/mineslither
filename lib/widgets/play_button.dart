import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      elevation: 20,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Icon(
        Icons.play_arrow,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
