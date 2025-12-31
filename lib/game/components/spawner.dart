import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../suika_game.dart';
import '../constants.dart';

class Spawner extends PositionComponent with HasGameReference<SuikaGame> {
  Sprite? _currentSprite;
  FruitType? _lastFruitType;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position to follow pointer
    if (game.currentFruitType != null) {
      position = game.pointerPosition.clone();
      
      // Load sprite if fruit type changed
      if (_lastFruitType != game.currentFruitType) {
        _lastFruitType = game.currentFruitType;
        _loadSprite();
      }
    }
  }

  Future<void> _loadSprite() async {
    if (_lastFruitType != null) {
      try {
        _currentSprite = await game.loadSprite(_lastFruitType!.spriteFile);
      } catch (e) {
        // Sprite loading failed
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (game.currentFruitType != null && _currentSprite != null) {
      final radius = game.currentFruitType!.radius;
      final size = radius * 1.9; // Match fruit rendering size
      
      // Draw semi-transparent preview sprite
      canvas.save();
      
      final paint = Paint()..color = Colors.white.withOpacity(0.8);
      _currentSprite!.render(
        canvas,
        position: Vector2(-size / 2, -size / 2),
        size: Vector2.all(size),
        overridePaint: paint,
      );
      
      canvas.restore();
      
      // Draw vertical guide line
      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..strokeWidth = 0.03;
      canvas.drawLine(
        Offset(0, radius),
        Offset(0, 8.0), // Line down to bottom
        linePaint,
      );
    }
  }
}
