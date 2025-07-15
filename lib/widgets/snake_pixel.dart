import 'package:flutter/material.dart';

import '../screens/game_screen.dart';

class SnakePixel extends StatelessWidget {
  final bool head;
  final Direction? direction;
  final Direction? nextDirection;
  final bool isTail;

  const SnakePixel({
    super.key,
    this.head = false,
    this.direction,
    this.nextDirection,
    this.isTail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: head ? Colors.green[700] : Colors.green[500],
        borderRadius: BorderRadius.circular(head ? 8 : 4),
        border: Border.all(
          color: head ? Colors.green[900]! : Colors.green[700]!,
          width: 1,
        ),
      ),
      child: head ? _buildSnakeHead() : _buildSnakeBody(),
    );
  }

  Widget _buildSnakeHead() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: RadialGradient(
          colors: [
            Colors.green[600]!,
            Colors.green[800]!,
          ],
        ),
      ),
      child: CustomPaint(
        painter: SnakeHeadPainter(direction: direction ?? Direction.right),
        size: const Size.square(24),
      ),
    );
  }

  Widget _buildSnakeBody() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [
            Colors.green[400]!,
            Colors.green[600]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isTail
          ? CustomPaint(
              painter:
                  SnakeTailPainter(direction: direction ?? Direction.right),
              size: const Size.square(24),
            )
          : Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
    );
  }
}

class SnakeHeadPainter extends CustomPainter {
  final Direction direction;

  SnakeHeadPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    const eyeRadius = 2.0;

    // Draw eyes based on direction
    Offset leftEye, rightEye;

    switch (direction) {
      case Direction.up:
        leftEye = Offset(center.dx - 4, center.dy - 2);
        rightEye = Offset(center.dx + 4, center.dy - 2);
        break;
      case Direction.down:
        leftEye = Offset(center.dx - 4, center.dy + 2);
        rightEye = Offset(center.dx + 4, center.dy + 2);
        break;
      case Direction.left:
        leftEye = Offset(center.dx - 2, center.dy - 4);
        rightEye = Offset(center.dx - 2, center.dy + 4);
        break;
      case Direction.right:
        leftEye = Offset(center.dx + 2, center.dy - 4);
        rightEye = Offset(center.dx + 2, center.dy + 4);
        break;
    }

    canvas.drawCircle(leftEye, eyeRadius, paint);
    canvas.drawCircle(rightEye, eyeRadius, paint);

    // Draw nostrils
    paint.color = Colors.black54;
    const nostrilRadius = 1.0;

    switch (direction) {
      case Direction.up:
        canvas.drawCircle(
            Offset(center.dx - 2, center.dy - 6), nostrilRadius, paint);
        canvas.drawCircle(
            Offset(center.dx + 2, center.dy - 6), nostrilRadius, paint);
        break;
      case Direction.down:
        canvas.drawCircle(
            Offset(center.dx - 2, center.dy + 6), nostrilRadius, paint);
        canvas.drawCircle(
            Offset(center.dx + 2, center.dy + 6), nostrilRadius, paint);
        break;
      case Direction.left:
        canvas.drawCircle(
            Offset(center.dx - 6, center.dy - 2), nostrilRadius, paint);
        canvas.drawCircle(
            Offset(center.dx - 6, center.dy + 2), nostrilRadius, paint);
        break;
      case Direction.right:
        canvas.drawCircle(
            Offset(center.dx + 6, center.dy - 2), nostrilRadius, paint);
        canvas.drawCircle(
            Offset(center.dx + 6, center.dy + 2), nostrilRadius, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SnakeTailPainter extends CustomPainter {
  final Direction direction;

  SnakeTailPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green[700]!
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw tail point based on direction
    final path = Path();

    switch (direction) {
      case Direction.up:
        path.moveTo(center.dx, size.height);
        path.lineTo(center.dx - 6, center.dy);
        path.lineTo(center.dx + 6, center.dy);
        path.close();
        break;
      case Direction.down:
        path.moveTo(center.dx, 0);
        path.lineTo(center.dx - 6, center.dy);
        path.lineTo(center.dx + 6, center.dy);
        path.close();
        break;
      case Direction.left:
        path.moveTo(size.width, center.dy);
        path.lineTo(center.dx, center.dy - 6);
        path.lineTo(center.dx, center.dy + 6);
        path.close();
        break;
      case Direction.right:
        path.moveTo(0, center.dy);
        path.lineTo(center.dx, center.dy - 6);
        path.lineTo(center.dx, center.dy + 6);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
