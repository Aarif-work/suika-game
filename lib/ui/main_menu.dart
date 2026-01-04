import 'package:flutter/material.dart';
import 'dart:ui';
import '../game/constants.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';
import 'widgets/atmosphere_background.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  GameTheme _selectedTheme = GameTheme.fruit;
  bool _isInverted = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpace = _selectedTheme == GameTheme.space;
    final Color accentColor = isSpace ? const Color(0xFF00d2ff) : const Color(0xFFe76f51);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSpace 
              ? [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)]
              : [const Color(0xFFfff1eb), const Color(0xFFace0f9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AtmosphereBackground(theme: _selectedTheme),
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                  // Theme Selection (Replacing the Logo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: GameTheme.values.map((theme) {
                      final isSelected = _selectedTheme == theme;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTheme = theme),
                        child: ScaleTransition(
                          scale: isSelected ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white.withOpacity(0.95) : Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: isSelected ? accentColor : Colors.white.withOpacity(0.9),
                                      width: isSelected ? 3 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected 
                                          ? accentColor.withOpacity(0.4)
                                          : Colors.black.withOpacity(0.1),
                                        blurRadius: isSelected ? 15 : 10,
                                        spreadRadius: isSelected ? 2 : 0,
                                      )
                                    ],
                                    gradient: isSelected ? LinearGradient(
                                      colors: [
                                        Colors.white,
                                        accentColor.withOpacity(0.15),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ) : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        theme.emoji,
                                        style: TextStyle(
                                          fontSize: isSelected ? 48 : 38,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(isSelected ? 0.15 : 0.05),
                                              offset: const Offset(0, 4),
                                              blurRadius: isSelected ? 8 : 4,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        theme.name.toUpperCase(),
                                        style: TextStyle(
                                          color: isSelected ? accentColor : Colors.black54,
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Gravity Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGravityOption(
                        label: 'Normal',
                        icon: Icons.arrow_downward,
                        isActive: !_isInverted,
                        accentColor: accentColor,
                        onTap: () => setState(() => _isInverted = false),
                      ),
                      _buildGravityOption(
                        label: 'Inverted',
                        icon: Icons.arrow_upward,
                        isActive: _isInverted,
                        accentColor: accentColor,
                        onTap: () => setState(() => _isInverted = true),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  
                  // Game Title
                  Text(
                    'SUIKA GAME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: isSpace ? Colors.white : accentColor,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: isSpace ? 15 : 4,
                          color: isSpace ? accentColor.withOpacity(0.6) : Colors.black26,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  // Menu Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _MenuButton(
                          text: 'PLAY',
                          emoji: '▶️',
                          color: accentColor,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  mode: GameMode.classic,
                                  theme: _selectedTheme,
                                  isInverted: _isInverted,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'HOW TO PLAY',
                          emoji: '❓',
                          color: const Color(0xFF2a9d8f),
                          onPressed: () => _showHowToPlay(context),
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'LEADERBOARD',
                          emoji: '🏆',
                          color: const Color(0xFF9c88ff),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'SETTINGS',
                          emoji: '⚙️',
                          color: const Color(0xFFf4a261),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Made with Flutter & Flame',
                      style: TextStyle(
                        color: isSpace ? Colors.white60 : Colors.black45,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
}


  Widget _buildGravityOption({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: isActive ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white.withOpacity(0.95) : Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? accentColor : Colors.white.withOpacity(0.9),
                      width: isActive ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isActive 
                          ? accentColor.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                        blurRadius: isActive ? 12 : 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                    gradient: isActive ? LinearGradient(
                      colors: [
                        Colors.white,
                        accentColor.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ) : null,
                  ),
                  child: Row(
                    children: [
                      _PhoneIcon(
                        icon: icon,
                        isActive: isActive,
                        accentColor: accentColor,
                        isInverted: label.toLowerCase() == 'inverted',
                      ),
                      const SizedBox(width: 10),
                       Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          color: isActive ? accentColor : Colors.black54,
                          fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isActive)
              Positioned(
                top: -6,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: accentColor,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: 'How to Play',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoItem('🎯', 'Tap to drop fruits'),
            _InfoItem('🍉', 'Merge same fruits to score'),
            _InfoItem('⬆️', 'Inverted mode: fruits fall UP!'),
            _InfoItem('🏆', 'Reach the max fruit to win'),
          ],
        ),
      ),
    );
  }
}

class _PhoneIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color accentColor;
  final bool isInverted;

  const _PhoneIcon({
    required this.icon,
    required this.isActive,
    required this.accentColor,
    required this.isInverted,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? accentColor : Colors.black87;
    final bodyColor = isActive ? Colors.white : Colors.white.withOpacity(0.9);
    
    // To have the arrow point UP when the phone is flipped (inverted),
    // we use Icons.arrow_downward and let the 180deg rotation handle it.
    final displayIcon = Icons.arrow_downward;
    
    return Transform.rotate(
      angle: isInverted ? 3.14159 : 0, // 180 degrees for inverted
      child: Container(
        width: 32,
        height: 52,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: bodyColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Home indicator/Notch area
            Positioned(
              top: 0,
              child: Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            // Screen area
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 2),
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Icon(
                  displayIcon,
                  color: color,
                  size: 18,
                ),
              ),
            ),
            // Home button detail
            Positioned(
              bottom: 0,
              child: Container(
                width: 4,
                height: 1,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final String emoji;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.emoji,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  final String title;
  final Widget content;

  const _InfoDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFe76f51),
                  ),
                ),
                const SizedBox(height: 20),
                content,
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2a9d8f),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Got it!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  class _InfoItem extends StatelessWidget {
  final String emoji;
  final String text;

  const _InfoItem(this.emoji, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Color(0xFF6d6875)),
            ),
          ),
        ],
      ),
    );
  }
}
