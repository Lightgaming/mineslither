import 'package:flutter/material.dart';

class SnakePixel extends StatelessWidget {
  const SnakePixel({
    super.key,
    this.head = false,
  });

  final bool head;

  @override
  Widget build(BuildContext context) {
    // Show snake head if head is true
    return Container(
      decoration: BoxDecoration(
        color: head ? Colors.green : Colors.green[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
