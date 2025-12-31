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
    // We can use TextPainter for simple text
    final textSpan = TextSpan(
      text: 'Score: ${game.score}',
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }
}

