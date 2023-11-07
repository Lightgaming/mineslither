import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mineslither/utils/app_settings.dart';
import 'package:mineslither/utils/logger.dart';
import 'package:mineslither/utils/pixel.dart';
import 'package:mineslither/widgets/app_bar.dart';
import 'package:mineslither/widgets/closed_pixel.dart';
import 'package:mineslither/widgets/food_pixel.dart';
import 'package:mineslither/widgets/open_pixel.dart';
import 'package:mineslither/widgets/play_button.dart';
import 'package:mineslither/widgets/snake_pixel.dart';

enum Direction { up, down, left, right }

const width = 32;
const height = 24;
const int bombProbability = 4;
const int maxProbability = 15;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? gameTimer;
  Widget? playButton;
  Direction lastDirection = Direction.right;
  int bombCount = 0;
  int foodCount = 0;
  double hunger = 0;
  int period = 900;

  List<Pixel> snake = [];

  List<List<Pixel>> board = [];

  // init the game
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _play() {
    setState(() {
      GameLogger.log('Starting game...');
      gameTimer?.cancel();
      gameTimer = Timer.periodic(Duration(milliseconds: period), (timer) {
        gameLoop();
      });
      playButton = null;
    });
  }

  void _initializeGame() {
    setState(() {
      GameLogger.log('Initialize game...');
      // Reset direction
      lastDirection = Direction.right;
      // Set Hunger
      hunger = 200;
      // Initialize all squares to having no bombs
      playButton = PlayButton(
        onPressed: () => _play(),
      );
      board.clear();
      board = List.generate(height, (i) {
        // snake.clear();
        return List.generate(width, (j) {
          if (i == 12 && (j == 13 || j == 14 || j == 15)) {
            snake.add(Pixel(
              rowNumber: i,
              columnNumber: j,
              bombsAround: 0,
              hasBomb: false,
              isRevealed: true,
              isFood: false,
            ));
          }
          return Pixel(
            rowNumber: i,
            columnNumber: j,
            bombsAround: 0,
            hasBomb: false,
            isRevealed: false,
            isFood: false,
          );
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

            if (board[i][j].hasBomb) {
              board[i][j].hasBomb = false;
              bombCount--;
            }
          }
        }
      }
    });

    calculateBombs();
  }

  void resetGame() {
    setState(() {
      playButton = PlayButton(
        onPressed: () => _play(),
      );
      snake = [];
      bombCount = 0;
      foodCount = 0;
      for (var i = 0; i < board.length; i++) {
        for (var j = 0; j < board[i].length; j++) {
          board[i][j].isRevealed = false;
        }
      }
    });
    _initializeGame();
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
    // Stop timer
    gameTimer?.cancel();

    if (!AppSettings().getEasyMode()) {
      setState(() {
        for (var i = 0; i < board.length; i++) {
          for (var j = 0; j < board[i].length; j++) {
            board[i][j].isRevealed = true;
          }
        }
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(reason),
          actions: [
            SizedBox(
              child: AppSettings().getEasyMode()
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        gameTimer = Timer.periodic(
                            const Duration(milliseconds: 1000), (timer) {
                          gameLoop();
                        });
                        hunger = 200;
                      },
                      child: const Text('continue'),
                    )
                  : null,
            ),
            TextButton(
              onPressed: () {
                if (AppSettings().getEasyMode()) {
                  setState(() {
                    for (var i = 0; i < board.length; i++) {
                      for (var j = 0; j < board[i].length; j++) {
                        board[i][j].isRevealed = true;
                      }
                    }
                  });

                  Navigator.of(context).pop();
                  return;
                } else {
                  resetGame();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('close'),
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

  void addSnakePixel(int rowNumber, int columnNumber, Direction direction) {
    snake.add(Pixel(
      rowNumber: direction.name == 'up'
          ? rowNumber - 1
          : direction.name == 'down'
              ? rowNumber + 1
              : rowNumber,
      columnNumber: direction.name == 'left'
          ? columnNumber - 1
          : direction.name == 'right'
              ? columnNumber + 1
              : columnNumber,
      bombsAround: 0,
      hasBomb: false,
      isRevealed: true,
      isFood: false,
    ));
  }

  bool checkIfSnakeEatsItself(
      int rowNumber, int columnNumber, Direction direction) {
    return snake.any(
      (element) =>
          element.rowNumber ==
              (direction.name == 'up'
                  ? rowNumber - 1
                  : direction.name == 'down'
                      ? rowNumber + 1
                      : rowNumber) &&
          element.columnNumber ==
              (direction.name == 'left'
                  ? columnNumber - 1
                  : direction.name == 'right'
                      ? columnNumber + 1
                      : columnNumber),
    );
  }

  bool checkIfSnakeHitsWall(
      int rowNumber, int columnNumber, Direction direction) {
    // if the snake hits the outer wall return true
    if (((direction.name == 'up' && rowNumber - 1 < 0) ||
        (direction.name == 'down' && rowNumber + 1 >= board.length) ||
        (direction.name == 'left' && columnNumber - 1 < 0) ||
        (direction.name == 'right' && columnNumber + 1 >= board[0].length))) {
      return true;
    }

    // if the snake hits a closed pixel return true
    return !board[direction.name == 'up'
            ? rowNumber - 1
            : direction.name == 'down'
                ? rowNumber + 1
                : rowNumber][direction.name == 'left'
            ? columnNumber - 1
            : direction.name == 'right'
                ? columnNumber + 1
                : columnNumber]
        .isRevealed;
  }

  void checkSnakeGameEnd(int rowNumber, int columnNumber, Direction direction) {
    // if the snake has no hunger left, game over
    if (hunger - 10 <= 0) {
      gameOver('You starved to death!');
    }
    // if the snake eats itself, game over
    if (checkIfSnakeEatsItself(rowNumber, columnNumber, lastDirection)) {
      gameTimer?.cancel();
      gameOver('You ate yourself!');
    }
    // if the snake hits the wall, game over
    if (checkIfSnakeHitsWall(rowNumber, columnNumber, lastDirection)) {
      gameTimer?.cancel();
      gameOver('You hit the wall!');
    }
  }

  void gameLoop() {
    setState(() {
      // add snake head to the and of the list
      int rowNumber = snake.last.rowNumber;
      int columnNumber = snake.last.columnNumber;

      checkSnakeGameEnd(rowNumber, columnNumber, lastDirection);
      addSnakePixel(rowNumber, columnNumber, lastDirection);

      hunger -= 10;

      // remove snake head
      if (!board[rowNumber][columnNumber].isFood) {
        snake.removeAt(0);
      } else {
        board[rowNumber][columnNumber].isFood = false;
        foodCount--;
        hunger = 200;
      }

      GameLogger.logFull(
          gameTimer, lastDirection, bombCount, foodCount, hunger, period);

      if (bombCount == 0 && foodCount == 0) {
        winGame();
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
    if (playButton != null) return;
    setState(() {
      if (board[rowNumber][columnNumber].hasBomb) {
        // Remove bomb
        board[rowNumber][columnNumber].hasBomb = false;
        bombCount--;
        foodCount++;
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
        board[rowNumber][columnNumber] = Pixel(
          rowNumber: rowNumber,
          columnNumber: columnNumber,
          bombsAround: 0,
          hasBomb: false,
          isRevealed: true,
          isFood: true,
        );
        calculateBombs();
      } else {
        // game over
        gameOver('You flagged an empty square!');
      }
    });
  }

  void handlePixelLeftClick(int rowNumber, int columnNumber) {
    if (playButton != null) return;

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
        if (lastDirection != Direction.up) {
          lastDirection = Direction.down;
        }
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
          value.isKeyPressed(LogicalKeyboardKey.keyW)) {
        if (lastDirection != Direction.down) {
          lastDirection = Direction.up;
        }
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft) ||
          value.isKeyPressed(LogicalKeyboardKey.keyA)) {
        if (lastDirection != Direction.right) {
          lastDirection = Direction.left;
        }
      } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight) ||
          value.isKeyPressed(LogicalKeyboardKey.keyD)) {
        if (lastDirection != Direction.left) {
          lastDirection = Direction.right;
        }
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
        floatingActionButton: playButton,
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
                    itemCount: height * width,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 32,
                    ),
                    itemBuilder: (context, index) {
                      int rowNumber = (index / width).floor();
                      int columnNumber = (index % width);

                      // snake state
                      if (snake.any((element) =>
                          element.columnNumber == columnNumber &&
                          element.rowNumber == rowNumber)) {
                        if (snake.last.rowNumber == rowNumber &&
                            snake.last.columnNumber == columnNumber) {
                          return const SnakePixel(head: true);
                        }
                        return const SnakePixel();
                      }

                      // food state
                      if (board[rowNumber][columnNumber].isFood) {
                        return const FoodPixel();
                      }

                      // open pixel
                      if (board[rowNumber][columnNumber].isRevealed) {
                        return OpenPixel(
                          number: board[rowNumber][columnNumber].bombsAround,
                          isBomb: board[rowNumber][columnNumber].hasBomb,
                          isRevealed: board[rowNumber][columnNumber].isRevealed,
                        );
                      }

                      // closed pixel
                      return ClosedPixel(
                        onLeftClick: () {
                          handlePixelLeftClick(rowNumber, columnNumber);
                        },
                        onRightClick: () {
                          handlePixelRightClick(rowNumber, columnNumber);
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: LinearProgressIndicator(
                  value: hunger / 200,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
