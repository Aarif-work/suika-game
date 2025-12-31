import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/suika_game.dart';

import 'game/components/game_over_overlay.dart';

void main() {
  runApp(GameWidget<SuikaGame>.controlled(
    gameFactory: SuikaGame.new,
    overlayBuilderMap: {
      'GameOver': (context, game) => GameOverOverlay(game: game),
    },
  ));
}
