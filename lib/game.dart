import 'dart:math';

enum BoxState { closed, open, flagged, isSnake, hasFood }

class Game {
  Game({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;
  final List<List<BoxState>> grid = [];

  void init() {
    for (var i = 0; i < width; i++) {
      grid.add(List.generate(height, (index) => BoxState.closed));
    }

    // Set Snake Initial Position
    grid[0][0] = BoxState.isSnake;

    // Set bombs
    for (var i = 0; i < 10; i++) {
      final x = Random().nextInt(width);
      final y = Random().nextInt(height);
      grid[x][y] = BoxState.flagged;
    }
  }
}
