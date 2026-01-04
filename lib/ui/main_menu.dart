import 'package:flutter/material.dart';
import 'dart:ui';
import '../game/constants.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  GameTheme _selectedTheme = GameTheme.fruit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfff1eb), Color(0xFFace0f9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const SizedBox(height: 60),
                  // Theme Selection (Replacing the Logo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: GameTheme.values.map((theme) {
                      final isSelected = _selectedTheme == theme;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTheme = theme),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFe76f51) : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: const Color(0xFFe76f51).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ] : [],
                          ),
                          child: Column(
                            children: [
                              Text(
                                theme.emoji,
                                style: TextStyle(
                                  fontSize: isSelected ? 48 : 36,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 4),
                                Text(
                                  theme.name,
                                  style: const TextStyle(
                                    color: Color(0xFFe76f51),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  
                  // Game Title
                  const Text(
                    'SUIKA GAME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFe76f51),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(2, 2),
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
                          color: const Color(0xFFe76f51),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  mode: GameMode.classic,
                                  theme: _selectedTheme,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'INVERTED MODE',
                          emoji: '🌌',
                          color: const Color(0xFF263238),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  mode: GameMode.classic,
                                  theme: _selectedTheme,
                                  isInverted: true,
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Made with Flutter & Flame',
                      style: TextStyle(
                        color: Color(0xFF6d6875),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            _InfoItem('🔄', 'Same fruits merge into bigger ones'),
            _InfoItem('📈', 'Score points by merging'),
            _InfoItem('⚠️', 'Don\'t let fruits reach the top!'),
            _InfoItem('🍉', 'Reach the watermelon for maximum points'),
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
