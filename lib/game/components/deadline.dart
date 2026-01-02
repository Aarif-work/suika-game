import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../suika_game.dart';

class Deadline extends PositionComponent with HasGameReference<SuikaGame> {
  static const double deadlineY = 0.8;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.08
      ..style = PaintingStyle.stroke;

    // Draw horizontal line across the world width
    canvas.drawLine(
      const Offset(0, deadlineY),
      Offset(SuikaGame.worldWidth, deadlineY),
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
    textPainter.paint(
      canvas,
      Offset((SuikaGame.worldWidth - textPainter.width) / 2, deadlineY - 0.3),
    );
  }
}
