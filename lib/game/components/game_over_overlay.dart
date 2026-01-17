import 'package:flutter/material.dart';
import '../suika_game.dart';
import 'dart:ui';

class GameOverOverlay extends StatefulWidget {
  final SuikaGame game;

  const GameOverOverlay({Key? key, required this.game}) : super(key: key);

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
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
                        color: const Color(0xFFe76f51).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_esports_rounded,
                        size: 48,
                        color: Color(0xFFe76f51),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nice Try!',
                      style: TextStyle(
                        color: Color(0xFFe76f51),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Your Score Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf4a261).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'YOUR SCORE',
                            style: TextStyle(
                              color: Color(0xFF6d6875),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.game.score}',
                            style: const TextStyle(
                              color: Color(0xFFf4a261),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Best Score (no container)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Best: ',
                          style: TextStyle(
                            color: Color(0xFF6d6875),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${widget.game.highScore}',
                          style: const TextStyle(
                            color: Color(0xFF2a9d8f),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Play Again Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.game.reset();
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
                            Icon(Icons.refresh_rounded, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'PLAY AGAIN',
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
                    // Home Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
