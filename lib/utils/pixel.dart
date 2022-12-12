import '../screens/game_screen.dart';

class Pixel {
  int rowNumber;
  int columnNumber;
  int bombsAround;
  bool hasBomb;
  bool isRevealed;
  bool isFood;

  Pixel({
    required this.rowNumber,
    required this.columnNumber,
    required this.bombsAround,
    required this.hasBomb,
    required this.isRevealed,
    required this.isFood,
  });
}

class Snake {
  List<Pixel> body;
  Direction direction;
  int length;
  int score;
  bool isDead;

  Snake({
    required this.body,
    required this.direction,
    required this.length,
    required this.score,
    required this.isDead,
  });
}
