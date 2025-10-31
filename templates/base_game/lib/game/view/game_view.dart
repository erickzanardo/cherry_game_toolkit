import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/game/game.dart';
import 'package:provider/provider.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final game = MyGame(gameAssets: context.read());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: game));
  }
}
