import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/suika_game.dart';
import '../game/components/game_over_overlay.dart';
import 'pause_overlay.dart';
import 'enhanced_hud.dart';
import 'widgets/atmosphere_background.dart';

import '../game/constants.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final GameTheme theme;
  final bool isInverted;

  const GameScreen({
    Key? key,
    this.mode = GameMode.classic,
    this.theme = GameTheme.fruit,
    this.isInverted = false,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SuikaGame game;

  @override
  void initState() {
    super.initState();
    game = SuikaGame(
      gameMode: widget.mode, 
      gameTheme: widget.theme,
      isInverted: widget.isInverted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.theme == GameTheme.space
              ? [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)]
              : [const Color(0xFFfff1eb), const Color(0xFFace0f9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                AtmosphereBackground(theme: widget.theme),
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
                Positioned.fill(
                  child: EnhancedHUD(game: game),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}