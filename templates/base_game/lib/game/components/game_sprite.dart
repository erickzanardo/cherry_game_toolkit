import 'dart:async';

import 'package:game/game/game.dart';
import 'package:flame/components.dart';

mixin HasSprite on PositionComponent {
  String get spriteId;
  set spriteId(String value);
}

class GameSprite extends SpriteComponent
    with HasGameReference<MyGame>, HasSprite {
  GameSprite({
    required String spriteId,
    super.position,
    super.angle,
    super.anchor,
    super.priority,
    super.children,
    super.bleed,
  }) : _spriteId = spriteId;

  late String _spriteId;
  @override
  String get spriteId => _spriteId;
  @override
  set spriteId(String value) {
    if (_spriteId != value) {
      _spriteId = value;
      _setSprite();
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _setSprite();
  }

  void _setSprite() {
    final spriteData = game.gameAssets.atlas.sprites[_spriteId];

    if (spriteData == null) {
      throw Exception('Sprite $_spriteId not found in the atlas');
    }

    final tileSize = game.gameAssets.atlas.tileSize.toDouble();

    final srcPosition = Vector2(
      spriteData.$1 * tileSize,
      spriteData.$2 * tileSize,
    );

    final srcSize = Vector2(
      (spriteData.$3 ?? 1) * tileSize,
      (spriteData.$4 ?? 1) * tileSize,
    );

    sprite = Sprite(
      game.gameAssets.atlasImage,
      srcPosition: srcPosition,
      srcSize: srcSize,
    );

    size = srcSize.clone();
  }
}

class RasterGameSprite extends PositionComponent with HasGameReference<MyGame> {
  RasterGameSprite({
    required String spriteId,
    super.position,
    super.angle,
    super.anchor,
    super.priority,
    super.children,
    this.bleed,
  }) : _spriteId = spriteId;

  String _spriteId;

  String get spriteId => _spriteId;

  set spriteId(String value) {
    if (_spriteId != value) {
      _spriteId = value;
      _setSprite();
    }
  }

  RasterSpriteComponent? _rasterSprite;

  double? bleed;

  Sprite? get sprite => _rasterSprite?.sprite;

  double get opacity => _rasterSprite?.opacity ?? 1.0;

  set opacity(double value) {
    _rasterSprite?.opacity = value;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _setSprite();
  }

  void _setSprite() {
    _rasterSprite?.removeFromParent();
    final spriteData = game.gameAssets.atlas.sprites[_spriteId];

    if (spriteData == null) {
      throw Exception('Sprite $_spriteId not found in the atlas');
    }

    final tileSize = game.gameAssets.atlas.tileSize.toDouble();

    final srcPosition = Vector2(
      spriteData.$1 * tileSize,
      spriteData.$2 * tileSize,
    );

    final srcSize = Vector2(
      (spriteData.$3 ?? 1) * tileSize,
      (spriteData.$4 ?? 1) * tileSize,
    );

    final sprite = Sprite(
      game.gameAssets.atlasImage,
      srcPosition: srcPosition,
      srcSize: srcSize,
    );

    size = srcSize.clone();

    add(
      _rasterSprite = RasterSpriteComponent(
        baseSprite: sprite,
        size: size,
        bleed: bleed,
      ),
    );
  }
}
