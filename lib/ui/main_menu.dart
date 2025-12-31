import 'package:flutter/material.dart';
import 'dart:ui';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';
import 'app_theme.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

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
                  // Game Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '🍒',
                          style: TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'SUIKA GAME',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFe76f51),
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Drop & Merge Fruits',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6d6875),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Menu Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _MenuButton(
                          text: 'PLAY',
                          icon: Icons.play_arrow,
                          color: const Color(0xFFe76f51),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GameScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'HOW TO PLAY',
                          icon: Icons.help_outline,
                          color: const Color(0xFF2a9d8f),
                          onPressed: () => _showHowToPlay(context),
                        ),
                        const SizedBox(height: 15),
                        _MenuButton(
                          text: 'LEADERBOARD',
                          icon: Icons.leaderboard,
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
                          icon: Icons.settings,
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

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: 'Settings',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volume_up, color: Color(0xFF2a9d8f)),
              title: const Text('Sound Effects'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color(0xFF2a9d8f),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.music_note, color: Color(0xFF2a9d8f)),
              title: const Text('Background Music'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color(0xFF2a9d8f),
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
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.icon,
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
            Icon(icon, size: 24),
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
                    color: Color(0xFFe76f51),
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