import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../suika_game.dart';

class Deadline extends PositionComponent with HasGameReference<SuikaGame> {
  double get _deadlineY => game.isInverted ? SuikaGame.worldHeight - 0.8 : 0.8;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.08
      ..style = PaintingStyle.stroke;

    // Draw horizontal line across the world width
    canvas.drawLine(
      Offset(0, _deadlineY),
      Offset(SuikaGame.worldWidth, _deadlineY),
      linePaint,
    );

    // Draw minimalist label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'DEADLINE',
        style: TextStyle(
          fontSize: 0.14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    final labelY = game.isInverted ? _deadlineY + 0.1 : _deadlineY - 0.3;
    textPainter.paint(
      canvas,
      Offset((SuikaGame.worldWidth - textPainter.width) / 2, labelY),
    );
  }
}
