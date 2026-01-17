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
  final Map<Fruit, double> _sameTierContactTimers = {};
  
  @override
  void update(double dt) {
     super.update(dt);
     timeAlive += dt;

     // 1️⃣ SMART MERGE ASSIST: Attraction logic
     _processAttraction(dt);
  }

  void _processAttraction(double dt) {
    _sameTierContactTimers.forEach((other, duration) {
      if (other.isRemoved) return;
      
      // Update duration
      _sameTierContactTimers[other] = duration + dt;
      
      // If contact persists > 100ms
      if (duration > 0.1) {
        // Dampen angular velocity for stability
        body.angularDamping = 5.0;
        
        // Gentle attraction force
        final direction = other.body.position - body.position;
        final distance = direction.length;
        if (distance > 0) {
          direction.normalize();
          // Apply a force proportional to the radius to handle larger fruits smoothly
          body.applyForce(direction * (type.radius * 20.0));
        }
      }
    });

    // Reset damping if no contacts are persistent
    if (_sameTierContactTimers.values.every((d) => d <= 0.1)) {
      body.angularDamping = 0.5;
    }
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = type.radius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: type.restitution, // 2️⃣ FASTER GAMEPLAY: Tier-based restitution
      friction: 0.15,
      density: 1.0,
    );

    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
      linearDamping: type.linearDamping, // 2️⃣ FASTER GAMEPLAY: Tier-based damping
      angle: (DateTime.now().millisecondsSinceEpoch % 360) * (3.14159 / 180),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
  
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    if (game.gameTheme == GameTheme.fruit || game.gameTheme == GameTheme.space) {
      try {
        _sprite = await game.loadSprite(type.getSpriteFile(game.gameTheme));
      } catch (e) {
        // Fallback
      }
    }
  }

  @override
  void render(Canvas canvas) {
    double margin = Constants.getVisualMargin(game.gameTheme);
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
      final textPainter = TextPainter(
        text: TextSpan(
          text: type.getEmoji(game.gameTheme),
          style: TextStyle(
            fontSize: visualDiameter * 0.9,
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
        // Add to attraction timers
        _sameTierContactTimers[other] = 0.0;
        
        // Immediate merge attempt if they hit hard or game logic says so
        if (game is SuikaGame) {
           (game as SuikaGame).onMerge(this, other);
        }
      }
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is Fruit) {
      _sameTierContactTimers.remove(other);
    }
  }
}
