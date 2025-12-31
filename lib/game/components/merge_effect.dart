import 'dart:math' as dart_math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class MergeEffect extends PositionComponent {
  final FruitType fromType;
  final FruitType toType;
  final Vector2 mergePosition;
  double animationTime = 0;
  final double effectDuration = 0.8;

  MergeEffect({
    required this.fromType,
    required this.toType,
    required this.mergePosition,
  });

  @override
  Future<void> onLoad() async {
    position = mergePosition.clone();
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTime += dt;
    
    if (animationTime >= effectDuration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = (animationTime / effectDuration).clamp(0.0, 1.0);
    
    // Expanding circle effect
    final expandRadius = progress * toType.radius * 2;
    final expandOpacity = (1.0 - progress).clamp(0.0, 1.0);
    
    final expandPaint = Paint()
      ..color = toType.color.withOpacity(expandOpacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.05;
    canvas.drawCircle(Offset.zero, expandRadius, expandPaint);
    
    // Particle burst effect
    if (progress < 0.5) {
      final particleProgress = progress * 2;
      for (int i = 0; i < 8; i++) {
        final angle = (i / 8) * 2 * dart_math.pi;
        final particleDistance = particleProgress * toType.radius * 1.5;
        final particleX = particleDistance * dart_math.cos(angle);
        final particleY = particleDistance * dart_math.sin(angle);
        
        final particlePaint = Paint()
          ..color = fromType.color.withOpacity((1.0 - particleProgress) * 0.8);
        canvas.drawCircle(
          Offset(particleX, particleY),
          0.05 * (1.0 - particleProgress),
          particlePaint,
        );
      }
    }
    
    // Score popup
    if (progress < 0.6) {
      final scoreOpacity = (1.0 - progress / 0.6).clamp(0.0, 1.0);
      final scoreY = -progress * toType.radius * 2;
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: '+${toType.score}',
          style: TextStyle(
            fontSize: toType.radius * 0.8,
            fontWeight: FontWeight.bold,
            color: Color.lerp(Colors.white, toType.color, 0.3)!.withOpacity(scoreOpacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, scoreY - textPainter.height / 2),
      );
    }
  }
}