import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../suika_game.dart';

class Fruit extends BodyComponent<SuikaGame> with ContactCallbacks {
  final FruitType type;
  final Vector2 initialPosition;

  Fruit(this.type, this.initialPosition);
  
  double timeAlive = 0;
  
  @override
  void update(double dt) {
     super.update(dt);
     timeAlive += dt;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = type.radius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.3, // Slightly more bounce
      friction: 0.15,  // Less friction to make them slippery
      density: 1.0,
    );

    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
      angle: (DateTime.now().millisecondsSinceEpoch % 360) * (3.14159 / 180), // Random starting angle
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
  
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load sprites if theme-specific assets exist
    if (game.gameTheme == GameTheme.fruit || game.gameTheme == GameTheme.space) {
      try {
        _sprite = await game.loadSprite(type.getSpriteFile(game.gameTheme));
      } catch (e) {
        // Sprite loading failed - will use fallback emoji
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Standardized visual diameter in meters
    double margin = Constants.visualMargin;
    final visualDiameter = type.radius * 2 * margin;
    
    if (_sprite != null) {
      final tint = type.getSpriteTint(game.gameTheme);
      if (tint != null) {
        canvas.save();
        final paint = Paint()
          ..colorFilter = ColorFilter.mode(tint, BlendMode.srcATop);
        _sprite!.render(
          canvas,
          position: Vector2(-visualDiameter / 2, -visualDiameter / 2),
          size: Vector2.all(visualDiameter),
          overridePaint: paint,
        );
        canvas.restore();
      } else {
        _sprite!.render(
          canvas,
          position: Vector2(-visualDiameter / 2, -visualDiameter / 2),
          size: Vector2.all(visualDiameter),
        );
      }
    } else {
      // Use thematic emoji
      final textPainter = TextPainter(
        text: TextSpan(
          text: type.getEmoji(game.gameTheme),
          style: TextStyle(
            fontSize: visualDiameter * 0.9, // Adjust so emoji fits nicely in the center
            fontFamily: 'Noto Color Emoji',
            height: 1.0, 
            color: type.getColor(game.gameTheme),
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
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Fruit) {
      if (other.type == type) {
        print('Crash! merging ${type.name}');
        // We need to ensure only one merge happens for this pair.
        // We can use a simple check: only the body with the lower ID (or similar determinant) triggers it.
        // Or simply let the game loop handle it.
        // Let's pass the event to the game class.
        if (game is SuikaGame) {
             (game as SuikaGame).onMerge(this, other);
        } else {
             // Fallback or error logging
             // print('Game is not SuikaGame!');
        }
      }
    }
  }
}
