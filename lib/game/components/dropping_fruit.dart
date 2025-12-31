import 'package:flame/components.dart';
import 'package:flame/extensions.dart'; 
import 'package:flutter/material.dart';
import '../constants.dart';
import '../suika_game.dart';
import 'fruit.dart';

class DroppingFruit extends PositionComponent with HasGameReference<SuikaGame> {
  final FruitType type;
  final Vector2 targetPosition;
  late Vector2 startPosition;
  double animationTime = 0;
  final double dropDuration = 0.5;
  bool hasLanded = false;
  Sprite? _sprite;

  DroppingFruit(this.type, this.targetPosition);

  @override
  Future<void> onLoad() async {
    startPosition = Vector2(targetPosition.x, -1.0);
    position = startPosition.clone();
    size = Vector2.all(type.radius * 2);
    anchor = Anchor.center;
    
    try {
      _sprite = await game.loadSprite(type.spriteFile);
    } catch (e) {
      print('Error loading sprite: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!hasLanded) {
      animationTime += dt;
      final progress = (animationTime / dropDuration).clamp(0.0, 1.0);
      
      // Easing function for bouncy drop
      final easedProgress = _easeOutBounce(progress);
      
      position = Vector2.lerp(startPosition, targetPosition, easedProgress)!;
      
      if (progress >= 1.0) {
        hasLanded = true;
        _createPhysicalFruit();
        removeFromParent();
      }
    }
  }

  double _easeOutBounce(double t) {
    if (t < 1 / 2.75) {
      return 7.5625 * t * t;
    } else if (t < 2 / 2.75) {
      return 7.5625 * (t -= 1.5 / 2.75) * t + 0.75;
    } else if (t < 2.5 / 2.75) {
      return 7.5625 * (t -= 2.25 / 2.75) * t + 0.9375;
    } else {
      return 7.5625 * (t -= 2.625 / 2.75) * t + 0.984375;
    }
  }

  void _createPhysicalFruit() {
    final fruit = Fruit(type, targetPosition);
    game.world.add(fruit);
  }

  @override
  void render(Canvas canvas) {
    final radius = type.radius;
    
    // Shadow
    final shadowOpacity = (1.0 - (position.y / targetPosition.y)).clamp(0.0, 0.3);
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(0.05, 0.05), radius * 0.8, shadowPaint);

    canvas.save();
    canvas.rotate(animationTime * 2);

    if (_sprite != null) {
      // Sprite size = 1.9x radius (fits within physics body)
      final size = radius * 1.9;
      _sprite!.render(
        canvas,
        position: Vector2(-size / 2, -size / 2),
        size: Vector2.all(size),
      );
    } else {
       // Fallback
       final bgPaint = Paint()..color = type.color;
       canvas.drawCircle(Offset.zero, radius, bgPaint);
       
       final textPainter = TextPainter(
        text: TextSpan(
          text: type.emoji,
          style: TextStyle(
            fontSize: radius * 1.5,
            fontFamily: 'Noto Color Emoji',
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
    canvas.restore();
  }
}
