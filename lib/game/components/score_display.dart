import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../suika_game.dart';

class ScoreDisplay extends PositionComponent with HasGameReference<SuikaGame> {
  ScoreDisplay() : super(position: Vector2(20, 50), anchor: Anchor.topLeft);

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  @override
  void render(Canvas canvas) {
    // 1. Draw "Glass" Background
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 180, 60), // Slightly larger for icon
      const Radius.circular(16),
    );

    // Gradient Shader for Glass effect
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x99FFFFFF), // White with 0.6 opacity
          Color(0x4DFFFFFF), // White with 0.3 opacity
        ],
      ).createShader(rrect.outerRect)
      ..style = PaintingStyle.fill;

    // Border Paint
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Shadow Paint
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw Shadow first
    canvas.drawRRect(rrect.shift(const Offset(4, 4)), shadowPaint);
    // Draw Glass Fill
    canvas.drawRRect(rrect, paint);
    // Draw Border
    canvas.drawRRect(rrect, borderPaint);

    // 2. Render Text with Trophy Icon
    _textPainter.text = TextSpan(
      children: [
        const TextSpan(
          text: '🏆 ',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        TextSpan(
          text: '${game.score}',
          style: const TextStyle(
            color: Color(0xFFe76f51),
            fontSize: 28,
            fontWeight: FontWeight.w900, // Extra bold
            shadows: [
              Shadow(
                color: Colors.black12,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );

    _textPainter.layout();
    
    // Center text in the card
    _textPainter.paint(
      canvas,
      Offset(
        (180 - _textPainter.width) / 2,
        (60 - _textPainter.height) / 2,
      ),
    );
  }
}

