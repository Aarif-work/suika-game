import 'package:flutter/material.dart';

class Constants {
  static const double gameWidth = 600;
  static const double gameHeight = 900;
  
  // Method to get visual margin based on theme
  static double getVisualMargin(GameTheme? theme) {
    // Space assets are full-bleed (no padding), so they need exact fit (1.0) to match physics circle.
    if (theme == GameTheme.space) return 1.25;
    
    // Fruit assets have some internal transparent padding, so we render them slightly larger (1.05)
    // to make the visible fruit boundaries match the physics circle.
    return 1.05; 
  }
}

enum GameMode {
  classic('Classic', 'Unlimited time to reach the highest score.'),
  oneMinute('1 Minute', 'Score as much as possible in 60 seconds.', durationSeconds: 60),
  twoMinutes('2 Minutes', 'Score as much as possible in 120 seconds.', durationSeconds: 120);

  final String name;
  final String description;
  final int? durationSeconds;

  const GameMode(this.name, this.description, {this.durationSeconds});
}

enum GameTheme {
  fruit(
    name: 'Fruit',
    emoji: '🍒\uFE0F',
  ),
  space(
    name: 'Space', 
    emoji: '🚀\uFE0F',
  );

  final String name;
  final String emoji;

  const GameTheme({
    required this.name,
    required this.emoji,
  });
}

enum FruitType {
  cherry(0.3, Color(0xFFff6b6b), 2, '🍒', 'circle0.png', 'pop0.mp3', linearDamping: 0.4, restitution: 0.25),
  strawberry(0.4, Color(0xFFff8e8e), 4, '🍓', 'circle1.png', 'pop1.mp3', linearDamping: 0.45, restitution: 0.23),
  grape(0.5, Color(0xFF9c88ff), 6, '🍇', 'circle2.png', 'pop2.mp3', linearDamping: 0.5, restitution: 0.21),
  orange(0.6, Color(0xFFffa726), 8, '🍊', 'circle3.png', 'pop3.mp3', linearDamping: 0.55, restitution: 0.19),
  apple(0.7, Color(0xFFef5350), 10, '🍎', 'circle4.png', 'pop4.mp3', linearDamping: 0.6, restitution: 0.17),
  pear(0.8, Color(0xFFc8e6c9), 12, '🍐', 'circle5.png', 'pop5.mp3', linearDamping: 0.65, restitution: 0.15),
  peach(0.9, Color(0xFFffcc80), 14, '🍑', 'circle6.png', 'pop6.mp3', linearDamping: 0.7, restitution: 0.13),
  pineapple(1.0, Color(0xFFffd54f), 16, '🍍', 'circle7.png', 'pop7.mp3', linearDamping: 0.75, restitution: 0.11),
  melon(1.1, Color(0xFFa5d6a7), 18, '🍈', 'circle8.png', 'pop8.mp3', linearDamping: 0.8, restitution: 0.09),
  watermelon(1.2, Color(0xFF66bb6a), 20, '🍉', 'circle9.png', 'pop9.mp3', linearDamping: 1.0, restitution: 0.05);

  const FruitType(this.radius, this.color, this.score, this.emoji, this.spriteFile, this.audioFile, {
    this.linearDamping = 0.5,
    this.restitution = 0.2,
  });

  final double radius;
  final Color color;
  final int score;
  final String emoji;
  final String spriteFile;
  final String audioFile;
  final double linearDamping;
  final double restitution;

  String getSpriteFile(GameTheme? theme) {
    if (theme == GameTheme.space) {
      // Map indices 0-9 to 1.png - 10.png
      return 'planets/${index + 1}.png';
    }
    return 'fruits/$spriteFile';
  }

  Color? getSpriteTint(GameTheme? theme) {
    return null;
  }

  String getEmoji(GameTheme? theme) {
    if (theme == null || theme == GameTheme.fruit) return emoji;
    
    const themeEmojis = {
      GameTheme.space: ['☄️', '🛰️', '🔭', '🌑', '🌙', '🌕', '🪐', '🌞', '🌌', '🛸'],
    };

    return themeEmojis[theme]?[index] ?? emoji;
  }

  Color getColor(GameTheme? theme) {
    if (theme == null || theme == GameTheme.fruit) return color;

    const themeColors = {
      GameTheme.space: [
        Color(0xFFB0BEC5), Color(0xFF90A4AE), Color(0xFF78909C), Color(0xFF607D8B),
        Color(0xFF546E7A), Color(0xFF455A64), Color(0xFF37474F), Color(0xFF263238),
        Color(0xFF212121), Color(0xFF000000)
      ],
    };

    return themeColors[theme]?[index] ?? color;
  }
}
