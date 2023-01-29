import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mineslither/screens/game_screen.dart';

class GameLogger {
  static const String _tag = "Mineslither";

  static void log(String message) {
    debugPrint("$_tag: $message");
  }

  static void logFull(
    Timer? gameTimer,
    Direction lastDirection,
    int bombCount,
    int foodCount,
    double hunger,
    int period,
  ) {
    debugPrint("$_tag: "
        "gameTimer: ${gameTimer?.tick}, "
        "lastDirection: ${lastDirection.name}, "
        "bombCount: $bombCount, "
        "foodCount: $foodCount, "
        "hunger: $hunger, "
        "period: $period, ");
  }
}
