import 'dart:math' as dart_math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

import '../suika_game.dart';

class MergeEffect extends PositionComponent with HasGameReference<SuikaGame> {
  final FruitType fromType;
  final FruitType toType;
  final Vector2 mergePosition;
  double animationTime = 0;
  final double effectDuration = 1.5; // Increased duration for "extra time"

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
    
    // Expanding circle effect (stays for the first 0.8s)
    final circleProgress = (animationTime / 0.8).clamp(0.0, 1.0);
    if (circleProgress < 1.0) {
      final expandRadius = circleProgress * toType.radius * 2;
      final expandOpacity = (1.0 - circleProgress).clamp(0.0, 1.0);
      
      final expandPaint = Paint()
        ..color = toType.getColor(game.gameTheme).withOpacity(expandOpacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.05;
      canvas.drawCircle(Offset.zero, expandRadius, expandPaint);
    }
    
    // Particle burst effect (stays for the first 0.5s)
    final particleProgressRaw = (animationTime / 0.5).clamp(0.0, 1.0);
    if (particleProgressRaw < 1.0) {
      for (int i = 0; i < 8; i++) {
        final angle = (i / 8) * 2 * dart_math.pi;
        final particleDistance = particleProgressRaw * toType.radius * 1.5;
        final particleX = particleDistance * dart_math.cos(angle);
        final particleY = particleDistance * dart_math.sin(angle);
        
        final particlePaint = Paint()
          ..color = fromType.getColor(game.gameTheme).withOpacity((1.0 - particleProgressRaw) * 0.8);
        canvas.drawCircle(
          Offset(particleX, particleY),
          0.05 * (1.0 - particleProgressRaw),
          particlePaint,
        );
      }
    }
    
    // Score popup - Clearly visible white points
    final scoreOpacity = (1.0 - progress).clamp(0.0, 1.0);
    final scoreY = -progress * toType.radius * 3; // Float higher up
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '+${toType.score}',
        style: TextStyle(
          fontSize: toType.radius * 1.2, // Larger font
          fontWeight: FontWeight.w900,
          color: Colors.white.withOpacity(scoreOpacity),
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(scoreOpacity * 0.8),
              offset: const Offset(0.02, 0.02),
              blurRadius: 0.04,
            ),
          ],
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