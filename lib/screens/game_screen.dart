// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mineslither/utils/app_settings.dart';
import 'package:mineslither/utils/logger.dart';
import 'package:mineslither/utils/pixel.dart';
import 'package:mineslither/utils/sound_manager.dart';
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
  Direction nextDirection = Direction.right; // Buffer for next direction
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
    SoundManager().playBackgroundMusic();
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
    SoundManager().playClickSound();
  }

  void _initializeGame() {
    setState(() {
      GameLogger.log('Initialize game...');
      // Reset direction
      lastDirection = Direction.right;
      nextDirection = Direction.right;
      // Set Hunger
      hunger = 200;
      // Initialize all squares to having no bombs
      playButton = PlayButton(
        onPressed: () => _play(),
      );
      board.clear();
      board = List.generate(height, (i) {
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

    if (reason.contains('bomb') || reason.contains('mine')) {
      SoundManager().playMineExplodeSound();
    } else {
      SoundManager().playGameOverSound();
    }

    SoundManager().pauseBackgroundMusic();

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

                        SoundManager().resumeBackgroundMusic();
                        SoundManager().playClickSound();
                      },
                      child: const Text('continue'),
                    )
                  : null,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (var i = 0; i < board.length; i++) {
                    for (var j = 0; j < board[i].length; j++) {
                      board[i][j].isRevealed = true;
                    }
                  }
                });
                resetGame();
                Navigator.of(context).pop();

                SoundManager().resumeBackgroundMusic();
                SoundManager().playClickSound();
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
    SoundManager().playWinSound();
    SoundManager().pauseBackgroundMusic();
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
                SoundManager().playClickSound();
                SoundManager().stopBackgroundMusic();
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
    if (checkIfSnakeEatsItself(rowNumber, columnNumber, direction)) {
      gameTimer?.cancel();
      gameOver('You ate yourself!');
    }
    // if the snake hits the wall, game over
    if (checkIfSnakeHitsWall(rowNumber, columnNumber, direction)) {
      gameTimer?.cancel();
      gameOver('You hit the wall!');
    }
  }

  void gameLoop() {
    setState(() {
      // Use the buffered direction
      lastDirection = nextDirection;

      // add snake head to the end of the list
      int rowNumber = snake.last.rowNumber;
      int columnNumber = snake.last.columnNumber;

      checkSnakeGameEnd(rowNumber, columnNumber, lastDirection);
      addSnakePixel(rowNumber, columnNumber, lastDirection);

      hunger -= 10;

      // remove snake tail
      if (!board[rowNumber][columnNumber].isFood) {
        snake.removeAt(0);
        if (snake.length % 5 == 0) {
          SoundManager().playMoveSound();
        }
      } else {
        board[rowNumber][columnNumber].isFood = false;
        foodCount--;
        hunger = 200;

        SoundManager().playEatSound();
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
        SoundManager().playMineDefuseSound();
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

    SoundManager().playClickSound();

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

  // Fixed direction handling to prevent immediate reversals
  void setCurrentDirection(RawKeyEvent value) {
    Direction newDirection = nextDirection;

    if (value.isKeyPressed(LogicalKeyboardKey.arrowDown) ||
        value.isKeyPressed(LogicalKeyboardKey.keyS)) {
      if (lastDirection != Direction.up) {
        newDirection = Direction.down;
      }
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
        value.isKeyPressed(LogicalKeyboardKey.keyW)) {
      if (lastDirection != Direction.down) {
        newDirection = Direction.up;
      }
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft) ||
        value.isKeyPressed(LogicalKeyboardKey.keyA)) {
      if (lastDirection != Direction.right) {
        newDirection = Direction.left;
      }
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight) ||
        value.isKeyPressed(LogicalKeyboardKey.keyD)) {
      if (lastDirection != Direction.left) {
        newDirection = Direction.right;
      }
    }

    setState(() {
      nextDirection = newDirection;
    });
  }

  Direction getSnakeDirection(int index) {
    if (index == snake.length - 1) {
      return lastDirection;
    }
    // For body segments, calculate direction based on position relative to next segment
    Pixel current = snake[index];
    Pixel next = snake[index + 1];

    if (current.rowNumber < next.rowNumber) return Direction.down;
    if (current.rowNumber > next.rowNumber) return Direction.up;
    if (current.columnNumber < next.columnNumber) return Direction.right;
    return Direction.left;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: (value) {
        setCurrentDirection(value);
      },
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

                      // Find snake segment index
                      int snakeIndex = -1;
                      for (int i = 0; i < snake.length; i++) {
                        if (snake[i].columnNumber == columnNumber &&
                            snake[i].rowNumber == rowNumber) {
                          snakeIndex = i;
                          break;
                        }
                      }

                      // snake state
                      if (snakeIndex != -1) {
                        bool isHead = snakeIndex == snake.length - 1;
                        bool isTail = snakeIndex == 0;
                        Direction segmentDirection =
                            getSnakeDirection(snakeIndex);

                        return SnakePixel(
                          head: isHead,
                          direction: segmentDirection,
                          isTail: isTail,
                        );
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
              // Enhanced hunger bar
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.restaurant,
                                  color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Hunger',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${hunger.toInt()}/200',
                            style: TextStyle(
                              fontSize: 12,
                              color: hunger > 50 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: hunger / 200,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              hunger > 100
                                  ? Colors.green
                                  : hunger > 50
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
