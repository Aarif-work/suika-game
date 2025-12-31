import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryOrange = Color(0xFFe76f51);
  static const Color secondaryTeal = Color(0xFF2a9d8f);
  static const Color accentYellow = Color(0xFFf4a261);
  static const Color backgroundLight = Color(0xFFfff1eb);
  static const Color backgroundDark = Color(0xFFace0f9);
  static const Color textDark = Color(0xFF6d6875);
  static const Color textLight = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundLight, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryOrange, Color(0xFFff8a65)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: primaryOrange,
    letterSpacing: 2,
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Colors.black26,
        offset: Offset(2, 2),
      ),
    ],
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryOrange,
    letterSpacing: 1,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryOrange,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    color: textDark,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: textDark,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: textDark,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: secondaryTeal,
    letterSpacing: 1,
  );
  
  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryOrange,
    foregroundColor: textLight,
    elevation: 8,
    shadowColor: primaryOrange.withOpacity(0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryTeal,
    foregroundColor: textLight,
    elevation: 6,
    shadowColor: secondaryTeal.withOpacity(0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );
  
  static ButtonStyle accentButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentYellow,
    foregroundColor: textLight,
    elevation: 4,
    shadowColor: accentYellow.withOpacity(0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
  
  // Card Decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground.withOpacity(0.9),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(
      color: Colors.white.withOpacity(0.5),
      width: 1,
    ),
  );
  
  static BoxDecoration hudCardDecoration = BoxDecoration(
    color: cardBackground.withOpacity(0.95),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 30.0;
}