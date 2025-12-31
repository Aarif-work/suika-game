import 'package:flutter/material.dart';

class Constants {
  static const double gameWidth = 600;
  static const double gameHeight = 900;
}

enum FruitType {
  cherry(0.375, Color(0xFFff6b6b), 10, '🍒', 'circle0.png', 'pop0.mp3'),
  strawberry(0.5, Color(0xFFff8e8e), 20, '🍓', 'circle1.png', 'pop1.mp3'),
  grape(0.625, Color(0xFF9c88ff), 40, '🍇', 'circle2.png', 'pop2.mp3'),
  orange(0.75, Color(0xFFffa726), 80, '🍊', 'circle3.png', 'pop3.mp3'),
  apple(0.875, Color(0xFFef5350), 160, '🍎', 'circle4.png', 'pop4.mp3'),
  pear(1.0, Color(0xFFc8e6c9), 320, '🍐', 'circle5.png', 'pop5.mp3'),
  peach(1.125, Color(0xFFffcc80), 640, '🍑', 'circle6.png', 'pop6.mp3'),
  pineapple(1.25, Color(0xFFffd54f), 1280, '🍍', 'circle7.png', 'pop7.mp3'),
  melon(1.375, Color(0xFFa5d6a7), 2560, '🍈', 'circle8.png', 'pop8.mp3'),
  watermelon(1.5, Color(0xFF66bb6a), 5120, '🍉', 'circle9.png', 'pop9.mp3');

  const FruitType(this.radius, this.color, this.score, this.emoji, this.spriteFile, this.audioFile);

  final double radius;
  final Color color;
  final int score;
  final String emoji;
  final String spriteFile;
  final String audioFile;
}
