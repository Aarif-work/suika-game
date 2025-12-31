import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import '../suika_game.dart';

class Spawner extends PositionComponent with HasGameRef<SuikaGame> {
  @override
  void render(Canvas canvas) {
    final fruitType = gameRef.currentFruitType;
    if (fruitType == null) return;
    
    // We are implementing simple render logic here
    // The component position should assume world coordinates if added to world?
    // Or if added to HUD?
    // We want it to be in the world so it aligns with physics bodies.
    
    final radius = fruitType.radius;
    final paint = Paint()..color = fruitType.color.withOpacity(0.5); // Ghost effect
    
    // Draw at the pointer position
    // Since this component might not be moving, we should technically update "position" in update()
    // But we can just draw at gameRef.pointerPosition if we want.
    // Better practice: update position in update cycle.
    
    canvas.drawCircle(Offset.zero, radius, paint);
    
    // Guide line
    final linePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.2)
      ..strokeWidth = 0.05;
    canvas.drawLine(Offset.zero, Offset(0, 10), linePaint); // Draw line down
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.currentFruitType != null) {
        position = gameRef.pointerPosition;
    }
  }
}
