import 'package:game/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  const GameView({required this.gameAssets, super.key});

  final GameAssets gameAssets;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final game = MyGame(gameAssets: widget.gameAssets);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: game));
  }
}
