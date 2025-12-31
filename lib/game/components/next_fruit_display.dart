import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import '../suika_game.dart';
import '../logic/fruit_manager.dart';

class NextFruitDisplay extends PositionComponent with HasGameReference<SuikaGame> {
  NextFruitDisplay() : super(position: Vector2(300, 50), anchor: Anchor.topRight); // Example pos

  @override
  Future<void> onLoad() async {
    // Determine position based on screen size? 
    // Usually HUD is fixed.
    // We are adding to Viewport, so position is screen coordinates.
    // Let's set it to top right corner.
    position = Vector2(game.canvasSize.x - 50, 50);
  }

  @override
  void render(Canvas canvas) {
    // Draw background box
    final bgPaint = Paint()..color = const Color(0xFF333333);
    final rect = Rect.fromCircle(center: Offset.zero, radius: 40);
    canvas.drawRect(rect, bgPaint);
    
    // Draw text "Next"
    // Text rendering in Flame is explicit. Let's skip text for now or draw simple.
    
    final nextFruit = game.nextFruitType;
    final radius = nextFruit.radius * 20; // Scale up for UI? Or keep relative?
    // Our physics radius is small (0.2). In pixels that is 0.2 * 100 = 20 pixels.
    
    final paint = Paint()..color = nextFruit.color;
    canvas.drawCircle(Offset.zero, radius, paint);
  }
  
  // Need to update position on resize?
  @override
  void onGameResize(Vector2 size) {
     super.onGameResize(size);
     position = Vector2(size.x - 50, 60);
  }
}

