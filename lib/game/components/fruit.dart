import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../suika_game.dart';

class Fruit extends BodyComponent with ContactCallbacks {
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
    try {
      _sprite = await game.loadSprite(type.spriteFile);
    } catch (e) {
      // Sprite loading failed - will use fallback emoji
    }
  }

  @override
  void render(Canvas canvas) {
    if (_sprite != null) {
      final radius = type.radius;
      // Sprite size = 1.9x radius (fits within 2.0x diameter physics body)
      final size = radius * 1.9;
      _sprite!.render(
        canvas,
        position: Vector2(-size / 2, -size / 2),
        size: Vector2.all(size),
      );
    } else {
      // Fallback to emoji if sprite fails
      final radius = type.radius;
      final textPainter = TextPainter(
        text: TextSpan(
          text: type.emoji,
          style: TextStyle(
            fontSize: radius * 1.75,
            fontFamily: 'Noto Color Emoji',
            height: 1.0, 
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
