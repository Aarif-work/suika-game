import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart'; // For Colors, Paint, Canvas

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final double strokeWidth;

  Wall(this.start, this.end, {this.strokeWidth = 1});

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this, 
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    // We are in world coordinates.
    // Let's draw a nice thick line for the wall.
    final paint = Paint()
      ..color = const Color(0xFFffffff).withOpacity(0.5)
      ..strokeWidth = 0.2 // in meters
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }
}
