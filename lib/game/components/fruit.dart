import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart'; // For Canvas/Paint
import '../logic/fruit_manager.dart';
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
      restitution: 0.2, // Bounciness
      friction: 0.4,
      density: 1.0,
    );

    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
  

  @override
  void render(Canvas canvas) {
    // ... existing render code ...
    final radius = type.radius;
    final paint = Paint()..color = type.color;
    canvas.drawCircle(Offset.zero, radius, paint);
    
    // Draw a border
    final borderPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.02; 
    canvas.drawCircle(Offset.zero, radius, borderPaint);
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
