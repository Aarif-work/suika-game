import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import '../suika_game.dart';

class ScoreDisplay extends PositionComponent with HasGameReference<SuikaGame> {
  ScoreDisplay() : super(position: Vector2(20, 50), anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    // positionType = PositionType.viewport; // Not needed if added to viewport
  }

  @override
  void render(Canvas canvas) {
    // Draw Card Background
    final bgRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 160, 50),
      const Radius.circular(15),
    );
    
    final bgPaint = Paint()..color = const Color(0xFFffffff).withOpacity(0.9);
    final shadowPaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawRRect(bgRect.shift(const Offset(2, 2)), shadowPaint);
    canvas.drawRRect(bgRect, bgPaint);

    // Render Text
    final textSpan = TextSpan(
      text: 'Score: ${game.score}',
      style: const TextStyle(
        color: Color(0xFFe76f51), // Burnt Sienna
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(
        (160 - textPainter.width) / 2, 
        (50 - textPainter.height) / 2
      )
    );
  }
}

