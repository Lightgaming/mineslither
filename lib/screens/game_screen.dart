import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mineslither/widgets/app_bar.dart';
import 'package:mineslither/widgets/bord_square.dart';
import 'package:mineslither/widgets/closed_pixel.dart';
import 'package:mineslither/widgets/food_pixel.dart';
import 'package:mineslither/widgets/open_pixel.dart';
import 'package:mineslither/widgets/snake_pixel.dart';

enum Direction { up, down, left, right }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // final Game game = Game(width: 32, height: 24);
  static const width = 32;
  static const height = 24;

  static const int bombProbability = 3;
  static const int maxProbability = 15;

  Timer? gameTimer;

  int bombCount = 0;

  List<int> snakePos = [
    (268 + width * 4),
    (268 + width * 4) + 1,
    (268 + width * 4) + 2,
    (268 + width * 4) + 3
  ];

  List<List<BoardSquare>> board = [];

  List<int> foodPos = [];

  Direction lastDirection = Direction.right;

  // init the game
  @override
  void initState() {
    super.initState();
    document.onContextMenu.listen((event) => event.preventDefault());
    // game.init();
    _initialiseGame();
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      gameLoop();
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  // Initialises all lists
  void _initialiseGame() {
    // Initialise all squares to having no bombs
    board = List.generate(height, (i) {
      return List.generate(width, (j) {
        return BoardSquare();
      });
    });

    // Randomly generate bombs
    Random random = Random();
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        int randomNumber = random.nextInt(maxProbability);
        if (randomNumber < bombProbability) {
          board[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }

    // Reveal in a radius 5 in the middle
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        if (i >= 9 && i <= 15 && j >= 10 && j <= 20) {
          board[i][j].isRevealed = true;
          board[i][j].hasBomb = false;
        }
      }
    }

    calculateBombs();
    setState(() {});
  }

  void calculateBombs() {
    // Check bombs around and assign numbers
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board[i].length; j++) {
        if (board[i][j].hasBomb) {
          // Check left
          if (j - 1 >= 0) {
            board[i][j - 1].bombsAround++;
          }
          // Check right
          if (j + 1 < board[i].length) {
            board[i][j + 1].bombsAround++;
          }
          // Check top
          if (i - 1 >= 0) {
            board[i - 1][j].bombsAround++;
          }
          // Check bottom
          if (i + 1 < board.length) {
            board[i + 1][j].bombsAround++;
          }
          // Check top left
          if (i - 1 >= 0 && j - 1 >= 0) {
            board[i - 1][j - 1].bombsAround++;
          }
          // Check top right
          if (i - 1 >= 0 && j + 1 < board[i].length) {
            board[i - 1][j + 1].bombsAround++;
          }
          // Check bottom left
          if (i + 1 < board.length && j - 1 >= 0) {
            board[i + 1][j - 1].bombsAround++;
          }
          // Check bottom right
          if (i + 1 < board.length && j + 1 < board[i].length) {
            board[i + 1][j + 1].bombsAround++;
          }
        }
      }
    }
  }

  void gameOver(String reason) {
    gameTimer?.cancel();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(reason),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void winGame() {
    gameTimer?.cancel();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You Win!'),
          content: const Text('You have won the game!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void gameLoop() {
    setState(() {
      // add snake head to the and of the list
      int rowNumber = (snakePos.last / width).floor();
      int columnNumber = (snakePos.last % width);
      switch (lastDirection) {
        case Direction.up:
          // if the snake eats itself, game over
          if (snakePos.any((element) => element == snakePos.last - width)) {
            gameTimer?.cancel();
            gameOver('You ate yourself!');
            break;
          }
          // if the snake hits the wall, game over
          if (!board[rowNumber - 1][columnNumber].isRevealed) {
            gameTimer?.cancel();
            gameOver('You hit the wall!');
            break;
          }
          snakePos.add(snakePos.last - width);
          break;
        case Direction.left:
          // if the snake eats itself, game over
          if (snakePos.any((element) => element == snakePos.last - 1)) {
            gameTimer?.cancel();
            gameOver('You ate yourself!');
            break;
          }
          if (!board[rowNumber][columnNumber - 1].isRevealed) {
            gameTimer?.cancel();
            gameOver('You hit the wall!');
            break;
          }
          snakePos.add(snakePos.last - 1);
          break;

        case Direction.right:
          // if the snake eats itself, game over
          if (snakePos.any((element) => element == snakePos.last + 1)) {
            gameTimer?.cancel();
            gameOver('You ate yourself!');
            break;
          }
          if (!board[rowNumber][columnNumber + 1].isRevealed) {
            gameTimer?.cancel();
            gameOver('You hit the wall!');
            break;
          }
          snakePos.add(snakePos.last + 1);
          break;

        case Direction.down:
          // if the snake eats itself, game over
          if (snakePos.any((element) => element == snakePos.last + width)) {
            gameTimer?.cancel();
            gameOver('You ate yourself!');
            break;
          }
          if (!board[rowNumber + 1][columnNumber].isRevealed) {
            gameTimer?.cancel();
            gameOver('You hit the wall!');
            break;
          }
          snakePos.add(snakePos.last + width);
          break;
        default:
          break;
      }

      // remove snake head
      if (!foodPos.any((element) => element == snakePos.last)) {
        snakePos.removeAt(0);
      } else {
        foodPos.remove(snakePos.last);
        if (foodPos.isEmpty && bombCount == 0) {
          winGame();
        }
      }
    });
  }

  void floodFill(int rowNumber, int columnNumber) {
    setState(() {
      for (var x = -1; x <= 1; x++) {
        for (var i = -1; i <= 1; i++) {
          if (rowNumber + x < height &&
              columnNumber + i < width &&
              rowNumber + x >= 0 &&
              columnNumber + i >= 0) {
            if ((board[rowNumber + x][columnNumber + i].bombsAround == 0) &&
                !board[rowNumber + x][columnNumber + i].isRevealed &&
                !board[rowNumber + x][columnNumber + i].hasBomb) {
              board[rowNumber + x][columnNumber + i].isRevealed = true;
              // floodFill(rowNumber, columnNumber);
              floodFill(rowNumber + x, columnNumber + i);
            }
          }
        }
      }
    });
  }

  void handlePixelRightClick(int rowNumber, int columnNumber) {
    setState(() {
      if (board[rowNumber][columnNumber].hasBomb) {
        // Remove bomb
        board[rowNumber][columnNumber].hasBomb = false;
        bombCount--;
        // recalculate numbers
        for (var x = -1; x <= 1; x++) {
          for (var i = -1; i <= 1; i++) {
            // reveal all pixels around
            if (rowNumber + x < height &&
                columnNumber + i < width &&
                rowNumber + x >= 0 &&
                columnNumber + i >= 0) {
              if (!board[rowNumber + x][columnNumber + i].hasBomb) {
                board[rowNumber + x][columnNumber + i].isRevealed = true;
              }
            }
          }
        }
        // reset bomb numbers
        for (var i = 0; i < board.length; i++) {
          for (var j = 0; j < board[i].length; j++) {
            board[i][j].bombsAround = 0;
          }
        }
        foodPos.add(rowNumber * width + columnNumber);
        calculateBombs();
      } else {
        // game over
        gameOver('You flagged an empty square!');
      }
    });
  }

  void handlePixelLeftClick(int rowNumber, int columnNumber) {
    setState(() {
      if (board[rowNumber][columnNumber].hasBomb) {
        // game over
        gameOver('You hit a bomb!');
        return;
      }
      if (board[rowNumber][columnNumber].bombsAround == 0) {
        for (var x = -1; x <= 1; x++) {
          for (var i = -1; i <= 1; i++) {
            // reveal all pixels around
            if (rowNumber + x < height &&
                columnNumber + i < width &&
                rowNumber + x >= 0 &&
                columnNumber + i >= 0) {
              board[rowNumber + x][columnNumber + i].isRevealed = true;
            }
          }
        }
        floodFill(rowNumber, columnNumber);
      }
      if (board[rowNumber][columnNumber].bombsAround >= 1) {
        // open pixel
        board[rowNumber][columnNumber].isRevealed = true;
      }
    });
  }

  void setCurrentDirection(RawKeyEvent value) {
    setState(() {
      if (value.isKeyPressed(LogicalKeyboardKey.arrowDown) ||
          value.isKeyPressed(LogicalKeyboardKey.keyS)) {
        lastDirection = Direction.down;
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
          value.isKeyPressed(LogicalKeyboardKey.keyW)) {
        lastDirection = Direction.up;
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft) ||
          value.isKeyPressed(LogicalKeyboardKey.keyA)) {
        lastDirection = Direction.left;
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight) ||
          value.isKeyPressed(LogicalKeyboardKey.keyD)) {
        lastDirection = Direction.right;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: (value) => setCurrentDirection(value),
      focusNode: FocusNode(),
      autofocus: true,
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: const GameAppBar(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: AspectRatio(
                  aspectRatio: 32 / 24,
                  child: GridView.builder(
                    itemCount: 768,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 32,
                    ),
                    itemBuilder: (context, index) {
                      // return Text(index.toString());
                      int rowNumber = (index / width).floor();
                      int columnNumber = (index % width);
                      if (snakePos.contains(index)) {
                        if (index == snakePos.last) {
                          return const SnakePixel(head: true);
                        }
                        return const SnakePixel();
                      } else if (foodPos.contains(index)) {
                        return const FoodPixel();
                      } else if (board[rowNumber][columnNumber].isRevealed) {
                        return OpenPixel(
                          number: board[rowNumber][columnNumber].bombsAround,
                        );
                      } else {
                        return ClosedPixel(
                          onLeftClick: () {
                            handlePixelLeftClick(rowNumber, columnNumber);
                          },
                          onRightClick: () {
                            handlePixelRightClick(rowNumber, columnNumber);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              // Expanded(
              //     child: Container(
              //   color: Colors.green,
              //   child: Text(
              //       'Timer: ${gameTimer?.isActive.toString()} Last Direction: $lastDirection'),
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
