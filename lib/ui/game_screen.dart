import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/suika_game.dart';
import '../game/components/game_over_overlay.dart';
import 'pause_overlay.dart';
import 'enhanced_hud.dart';

import '../game/constants.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final GameTheme theme;

  const GameScreen({
    Key? key,
    this.mode = GameMode.classic,
    this.theme = GameTheme.fruit,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SuikaGame game;

  @override
  void initState() {
    super.initState();
    game = SuikaGame(gameMode: widget.mode, gameTheme: widget.theme);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if device is mobile (narrow width)
            final isMobile = constraints.maxWidth < 600;
            
            // Adjust padding based on device size
            final horizontalPadding = isMobile ? 0.0 : 16.0;
            final verticalPadding = isMobile ? 8.0 : 20.0;
            
            return Stack(
              children: [
                // Game area with responsive padding
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, 
                    vertical: verticalPadding
                  ),
                  child: Center(
                    child: Container(
                      width: isMobile ? constraints.maxWidth : null, // Full width on mobile
                      constraints: BoxConstraints(
                        maxWidth: 600, // Max width for desktop
                        maxHeight: constraints.maxHeight - (verticalPadding * 2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isMobile ? 0 : 20),
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
            );
          }
        ),
      ),
    );
  }
}