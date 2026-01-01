import 'package:flutter/material.dart';
import '../game/suika_game.dart';
import '../game/constants.dart';

class EnhancedHUD extends StatefulWidget {
  final SuikaGame game;

  const EnhancedHUD({Key? key, required this.game}) : super(key: key);

  @override
  State<EnhancedHUD> createState() => _EnhancedHUDState();
}

class _EnhancedHUDState extends State<EnhancedHUD> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top HUD
            Row(
              children: [
                // Score Card
                _HUDCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFf4a261),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          StreamBuilder<int>(
                            stream: _scoreStream(),
                            builder: (context, snapshot) {
                              return Text(
                                '${snapshot.data ?? widget.game.score}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFe76f51),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFFffd700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Best: ${widget.game.highScore}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6d6875),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Pause Button
                _HUDButton(
                  icon: Icons.pause,
                  color: const Color(0xFF6d6875),
                  onPressed: () {
                    widget.game.pauseEngine();
                    widget.game.overlays.add('Pause');
                  },
                ),
              ],
            ),
            const Spacer(),
            // Bottom HUD removed per user request
            /*
            if (widget.game.currentFruitType != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: widget.game.currentFruitType!.color.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.game.currentFruitType!.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          widget.game.currentFruitType!.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TAP TO DROP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2a9d8f),
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          widget.game.currentFruitType!.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFe76f51),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            */
          ],
        ),
      ),
    );
  }

  Stream<int> _scoreStream() async* {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) yield widget.game.score;
    }
  }
}

class _HUDCard extends StatelessWidget {
  final Widget child;

  const _HUDCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _HUDButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _HUDButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 24),
        padding: EdgeInsets.zero,
      ),
    );
  }
}