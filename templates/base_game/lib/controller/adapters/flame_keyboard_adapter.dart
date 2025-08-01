import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game/controller/controller.dart';

class FlameKeyboardAdapter<T> extends Component with KeyboardHandler {
  FlameKeyboardAdapter({
    required this.listener,
    required Map<T, LogicalKeyboardKey> Function() keyMap,
  }) : _keyMap = keyMap;

  final ControllerListener<T> listener;
  final Map<T, LogicalKeyboardKey> Function() _keyMap;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final logicalKey = event.logicalKey;

    final mappedKey = _keyMap().findControl(logicalKey);

    if (mappedKey != null) {
      final eventType = event is KeyUpEvent
          ? ControllerEventType.up
          : ControllerEventType.down;

      listener.trigger(mappedKey, eventType);

      return false;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
