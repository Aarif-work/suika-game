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
            colors: [
              Color(0xFF667eea), // Purple
              Color(0xFF764ba2), // Deep purple
              Color(0xFFf093fb), // Pink
              Color(0xFF4facfe), // Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Game area with padding and background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a2e),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: GameWidget<SuikaGame>.controlled(
                      gameFactory: () => game,
                      overlayBuilderMap: {
                        'GameOver': (context, game) => GameOverOverlay(game: game),
                        'Pause': (context, game) => PauseOverlay(game: game),
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Enhanced HUD overlay
            EnhancedHUD(game: game),
          ],
        ),
      ),
    );
  }
}