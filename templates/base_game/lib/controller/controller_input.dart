import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:game/controller/controller.dart';
import 'package:game/game/game.dart';

mixin ControllerInput on HasGameReference<MyGame> {
  @override
  @mustCallSuper
  FutureOr<void> onLoad() async {
    await super.onLoad();

    game.controller.addListener(onControllerInput);
  }

  @override
  void onRemove() {
    super.onRemove();
    game.controller.removeListener(onControllerInput);
  }

  void onControllerInput(GameControl control, ControllerEventType type) {}
}
