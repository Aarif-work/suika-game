import 'package:flutter/material.dart';

class Constants {
  static const double gameWidth = 600;
  static const double gameHeight = 900;
  static const double visualMargin = 1.05; // Assets rendered at 105% to ensure visual contact (compensating for sprite padding)
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
  cherry(0.3, Color(0xFFff6b6b), 10, '🍒', 'circle0.png', 'pop0.mp3'),
  strawberry(0.4, Color(0xFFff8e8e), 20, '🍓', 'circle1.png', 'pop1.mp3'),
  grape(0.5, Color(0xFF9c88ff), 40, '🍇', 'circle2.png', 'pop2.mp3'),
  orange(0.6, Color(0xFFffa726), 80, '🍊', 'circle3.png', 'pop3.mp3'),
  apple(0.7, Color(0xFFef5350), 160, '🍎', 'circle4.png', 'pop4.mp3'),
  pear(0.8, Color(0xFFc8e6c9), 320, '🍐', 'circle5.png', 'pop5.mp3'),
  peach(0.9, Color(0xFFffcc80), 640, '🍑', 'circle6.png', 'pop6.mp3'),
  pineapple(1.0, Color(0xFFffd54f), 1280, '🍍', 'circle7.png', 'pop7.mp3'),
  melon(1.1, Color(0xFFa5d6a7), 2560, '🍈', 'circle8.png', 'pop8.mp3'),
  watermelon(1.2, Color(0xFF66bb6a), 5120, '🍉', 'circle9.png', 'pop9.mp3');

  const FruitType(this.radius, this.color, this.score, this.emoji, this.spriteFile, this.audioFile);

  final double radius;
  final Color color;
  final int score;
  final String emoji;
  final String spriteFile;
  final String audioFile;

  String getSpriteFile(GameTheme? theme) {
    if (theme == GameTheme.space) {
      if (index == 0) return 'planets/planet.png'; // New first planet
      if (index == 1) return 'planets/planet0.png'; // Was Mercury
      if (index == 2) return 'planets/planet1.png'; // Was Venus
      if (index == 3) return 'planets/planet2.png'; // Was Earth
      if (index == 4) return 'planets/planet3.png'; // Was Mars
      if (index == 5) return 'planets/planet4.png'; // Was Jupiter
      if (index == 6) return 'planets/planet5.png'; // Was Saturn
      
      // Reuse bases for higher tiers with tints
      if (index == 7) return 'planets/planet2.png'; // Neptune base (reused)
      if (index == 8) return 'planets/planet4.png'; // Sun base (reused)
      if (index == 9) return 'planets/planet5.png'; // Black Hole base (reused)
    }
    return 'fruits/$spriteFile';
  }

  Color? getSpriteTint(GameTheme? theme) {
    if (theme == GameTheme.space) {
      if (index == 7) return const Color(0xFF0D47A1).withOpacity(0.6); // Neptune Deep Blue tint
      if (index == 8) return const Color(0xFFFFEB3B).withOpacity(0.5); // Sun Yellow tint
      if (index == 9) return const Color(0xFF673AB7).withOpacity(0.7); // Black Hole Purple tint
    }
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
