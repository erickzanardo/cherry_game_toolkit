import 'package:flutter/services.dart';

enum GameControl {
  // Movement
  moveLeft,
  moveRight,
  moveUp,
  moveDown,

  // Actions
  buttonB,
  buttonA,
  buttonX,
  buttonY,
  buttonL,
  buttonR,
  start;

  static GameControl fromName(String name) {
    return GameControl.values.firstWhere(
      (control) => control.name == name,
      orElse: () => throw ArgumentError('No GameControl with name $name'),
    );
  }
}

class ControllerMappings {
  static final defaultKeyboard = {
    GameControl.moveLeft: LogicalKeyboardKey.keyA,
    GameControl.moveRight: LogicalKeyboardKey.keyD,
    GameControl.moveUp: LogicalKeyboardKey.keyW,
    GameControl.moveDown: LogicalKeyboardKey.keyS,

    // Actions
    GameControl.buttonB: LogicalKeyboardKey.keyN,
    GameControl.buttonA: LogicalKeyboardKey.keyM,
    GameControl.buttonY: LogicalKeyboardKey.keyJ,
    GameControl.buttonX: LogicalKeyboardKey.keyK,
    GameControl.buttonR: LogicalKeyboardKey.keyE,
    GameControl.buttonL: LogicalKeyboardKey.keyQ,
    GameControl.start: LogicalKeyboardKey.enter,
  };

  late Map<GameControl, LogicalKeyboardKey> keyboardMap;
}
