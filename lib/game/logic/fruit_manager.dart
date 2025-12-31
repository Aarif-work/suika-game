import 'dart:ui';

enum FruitType {
  cherry(0, 0.2, Color(0xFFF00000), 1),
  strawberry(1, 0.3, Color(0xFFE84C3D), 2),
  grape(2, 0.4, Color(0xFF9B59B6), 4),
  dekopon(3, 0.5, Color(0xFFE67E22), 8),
  orange(4, 0.6, Color(0xFFF39C12), 16),
  apple(5, 0.7, Color(0xFFC0392B), 32),
  pear(6, 0.8, Color(0xFFF1C40F), 64),
  peach(7, 0.9, Color(0xFFFAB1B1), 128),
  pineapple(8, 1.0, Color(0xFFF39C12), 256),
  melon(9, 1.2, Color(0xFF2ECC71), 512),
  watermelon(10, 1.4, Color(0xFF27AE60), 1024);

  final double radius;
  final Color color;
  final int score;

  const FruitType(int index, this.radius, this.color, this.score);
  
  static FruitType get(int index) => values[index % values.length];
}
