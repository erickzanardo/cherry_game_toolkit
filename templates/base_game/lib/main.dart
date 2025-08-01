import 'package:flutter/material.dart';
import 'package:game/game/game.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([GoogleFonts.pressStart2p()]);

  final theme = ThemeData(textTheme: GoogleFonts.pressStart2pTextTheme());

  final gameAssets = await GameAssets.load();

  runApp(
    MaterialApp(
      theme: theme,
      home: GameView(gameAssets: gameAssets),
    ),
  );
}
