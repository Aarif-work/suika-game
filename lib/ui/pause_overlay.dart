import 'package:flutter/material.dart';
import 'dart:ui';
import '../game/suika_game.dart';
import 'main_menu.dart';

class PauseOverlay extends StatelessWidget {
  final SuikaGame game;

  const PauseOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Full screen container to block touches and dim background
    return GestureDetector(
      onTap: () {}, // Absorb taps so they don't reach the game
      child: Container(
        color: Colors.black.withOpacity(0.7),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.pause_circle_filled,
                      size: 64,
                      color: Color(0xFF2a9d8f),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Color(0xFFe76f51),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _PauseButton(
                      text: 'RESUME',
                      icon: Icons.play_arrow,
                      color: const Color(0xFF2a9d8f),
                      onPressed: () {
                        game.overlays.remove('Pause');
                        game.resumeEngine();
                      },
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      text: 'RESTART',
                      icon: Icons.refresh,
                      color: const Color(0xFFf4a261),
                      onPressed: () {
                        game.overlays.remove('Pause');
                        game.reset();
                      },
                    ),
                    const SizedBox(height: 12),
                    _PauseButton(
                      text: 'HOME',
                      icon: Icons.home,
                      color: const Color(0xFFe76f51),
                      onPressed: () {
                        // Ensure overlay is removed and engine resumed or disposed properly,
                        // though pushing replacement usually handles the widget disposal.
                        // Ideally we cleanup.
                        game.overlays.remove('Pause');
                        // Navigate to MainMenu
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainMenu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _PauseButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}