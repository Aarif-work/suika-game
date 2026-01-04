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
    if (_lastFruitType != null && (game.gameTheme == GameTheme.fruit || game.gameTheme == GameTheme.space)) {
      try {
        _currentSprite = await game.loadSprite(_lastFruitType!.getSpriteFile(game.gameTheme));
      } catch (e) {
        // Sprite loading failed
        _currentSprite = null;
      }
    } else {
      _currentSprite = null;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (game.currentFruitType != null) {
      final type = game.currentFruitType!;
      final visualDiameter = type.radius * 2 * Constants.visualMargin;
      
      if (_currentSprite != null) {
        final tint = type.getSpriteTint(game.gameTheme);
        canvas.save();
        final paint = Paint()..color = Colors.white.withOpacity(0.8);
        if (tint != null) {
          paint.colorFilter = ColorFilter.mode(tint, BlendMode.srcATop);
        }
        _currentSprite!.render(
          canvas,
          position: Vector2(-visualDiameter / 2, -visualDiameter / 2),
          size: Vector2.all(visualDiameter),
          overridePaint: paint,
        );
        canvas.restore();
      } else {
        // Render thematic emoji
        final textPainter = TextPainter(
          text: TextSpan(
            text: type.getEmoji(game.gameTheme),
            style: TextStyle(
              fontSize: visualDiameter * 0.9,
              fontFamily: 'Noto Color Emoji',
              height: 1.0, 
              color: type.getColor(game.gameTheme).withOpacity(0.6),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
      }
      
      // Draw vertical guide line
      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..strokeWidth = 0.03;
      
      if (game.isInverted) {
        canvas.drawLine(
          Offset(0, -type.radius),
          Offset(0, -8.0), // Line up to top
          linePaint,
        );
      } else {
        canvas.drawLine(
          Offset(0, type.radius),
          Offset(0, 8.0), // Line down to bottom
          linePaint,
        );
      }
    }
  }
}
