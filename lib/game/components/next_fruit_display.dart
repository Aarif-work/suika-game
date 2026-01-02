import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../suika_game.dart';
import '../constants.dart';

class NextFruitDisplay extends PositionComponent with HasGameReference<SuikaGame> {
  NextFruitDisplay() : super(position: Vector2(300, 50), anchor: Anchor.topRight); // Example pos

  @override
  Future<void> onLoad() async {
    // Determine position based on screen size? 
    // Usually HUD is fixed.
    // We are adding to Viewport, so position is screen coordinates.
    // Let's set it to top right corner.
    position = Vector2(game.canvasSize.x - 50, 50);
  }

  @override
  void render(Canvas canvas) {
    // Hidden per user request: Removing 'NEXT' fruit preview
    return;
  }
  
  @override
  void onGameResize(Vector2 size) {
     super.onGameResize(size);
     // Keep it anchored to top right with some margin
     position = Vector2(size.x - 20, 20);
  }
}

