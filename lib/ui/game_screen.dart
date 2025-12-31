import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/suika_game.dart';
import '../game/components/game_over_overlay.dart';
import 'pause_overlay.dart';
import 'enhanced_hud.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SuikaGame game;

  @override
  void initState() {
    super.initState();
    game = SuikaGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfff1eb), Color(0xFFace0f9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            GameWidget<SuikaGame>.controlled(
              gameFactory: () => game,
              overlayBuilderMap: {
                'GameOver': (context, game) => GameOverOverlay(game: game),
                'Pause': (context, game) => PauseOverlay(game: game),
              },
            ),
            // Enhanced HUD overlay
            EnhancedHUD(game: game),
          ],
        ),
      ),
    );
  }
}