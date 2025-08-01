import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_juice_box/effects.dart';
import 'package:game/controller/controller.dart';
import 'package:game/game/game.dart';

export 'game_view.dart';
export 'game_assets.dart';
export 'components/components.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  MyGame({required this.gameAssets});

  final GameAssets gameAssets;
  late final ControllerListener<GameControl> controller;
  late final GameSprite ball;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    controller = ControllerListener<GameControl>();
    add(
      FlameKeyboardAdapter(
        listener: controller,
        keyMap: () => ControllerMappings.defaultKeyboard,
      ),
    );

    controller.addListener(_onControllerInput);

    camera = CameraComponent.withFixedResolution(width: 80, height: 80);

    world.add(ball = GameSprite(spriteId: 'ball'));
  }

  @override
  void onRemove() {
    super.onRemove();
    controller.removeListener(_onControllerInput);
  }

  void _onControllerInput(GameControl control, ControllerEventType type) {
    if (control == GameControl.buttonB && type == ControllerEventType.up) {
      if (ball.firstChild<BounceEffect>() == null) {
        ball.add(BounceEffect(Vector2(0, -2)));
      }
    }
  }
}
