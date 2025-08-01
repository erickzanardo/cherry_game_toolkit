import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:typled/typled.dart';

class GameAssets {
  GameAssets._({
    required this.atlasImage,
    required this.atlas,
    required this.images,
    required this.assets,
  });

  final Image atlasImage;
  final TypledAtlas atlas;
  final Images images;
  final AssetsCache assets;

  static const musics = <String>[];

  static Future<GameAssets> load() async {
    final assets = AssetsCache();
    final images = Images(prefix: 'assets/');

    final rawAtlas = await assets.readFile('sprites.typled_atlas');
    final atlas = TypledAtlas.parse(rawAtlas);

    final atlasImage = await images.load(atlas.imagePath);

    return GameAssets._(
      atlasImage: atlasImage,
      atlas: atlas,
      images: images,
      assets: assets,
    );
  }
}
