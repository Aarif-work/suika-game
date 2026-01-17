import 'package:flutter/material.dart';
import 'dart:ui';
import '../game/suika_game.dart';
import 'main_menu.dart';
import 'package:flame_audio/flame_audio.dart';

class PauseOverlay extends StatefulWidget {
  final SuikaGame game;

  const PauseOverlay({Key? key, required this.game}) : super(key: key);

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  bool isSoundEnabled = true;

  void _toggleSound() {
    setState(() {
      isSoundEnabled = !isSoundEnabled;
      
      if (isSoundEnabled) {
        // Enable sound
        FlameAudio.bgm.resume();
      } else {
        // Disable sound - stop both BGM and sound effects
        FlameAudio.bgm.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Full screen container to block touches and dim background
    return GestureDetector(
      onTap: () {}, // Absorb taps so they don't reach the game
      child: Container(
        color: Colors.black.withOpacity(0),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2a9d8f).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.pause_circle_filled,
                        size: 48,
                        color: Color(0xFF2a9d8f),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Color(0xFF2a9d8f),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sound Toggle Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _toggleSound,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6d6875),
                          side: BorderSide(
                            color: const Color(0xFF6d6875).withOpacity(0.3),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isSoundEnabled ? 'SOUND ON' : 'SOUND OFF',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Resume Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.game.overlays.remove('Pause');
                          widget.game.resumeEngine();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2a9d8f),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow_rounded, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'RESUME',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Restart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.game.overlays.remove('Pause');
                          widget.game.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf4a261),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'RESTART',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Home Button (Text Button)
                    TextButton(
                      onPressed: () {
                        widget.game.overlays.remove('Pause');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainMenu()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6d6875),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'HOME',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
  }
}