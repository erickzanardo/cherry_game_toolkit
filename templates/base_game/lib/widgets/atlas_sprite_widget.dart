import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:game/game/game_assets.dart';
import 'package:provider/provider.dart';

class AtlasSpriteWidget extends StatelessWidget {
  const AtlasSpriteWidget({
    required this.spriteId,
    this.width = 48,
    this.height = 48,
    super.key,
  });

  const AtlasSpriteWidget.square({
    required this.spriteId,
    double dimension = 48,
    super.key,
  }) : width = dimension,
       height = dimension;

  final String spriteId;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final gameAssets = context.read<GameAssets>();

    final atlasData = gameAssets.atlas;
    final atlasImage = gameAssets.atlasImage;

    final spriteData = atlasData.sprites[spriteId]!;
    return SizedBox(
      width: width,
      height: height,
      child: SpriteWidget(
        sprite: Sprite(
          atlasImage,
          srcPosition: Vector2(
            (spriteData.$1 * atlasData.tileSize).toDouble(),
            (spriteData.$2 * atlasData.tileSize).toDouble(),
          ),
          srcSize: Vector2(
            ((spriteData.$3 ?? 1) * atlasData.tileSize).toDouble(),
            ((spriteData.$4 ?? 1) * atlasData.tileSize).toDouble(),
          ),
        ),
      ),
    );
  }
}
