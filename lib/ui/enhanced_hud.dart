import 'package:flutter/material.dart';
import '../game/suika_game.dart';
import '../game/constants.dart';

import 'progression_bar.dart';

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
                // Timer Card (only if timed mode)
                if (widget.game.gameMode.durationSeconds != null)
                  _HUDCard(
                    child: StreamBuilder<double?>(
                      stream: _timerStream(),
                      builder: (context, snapshot) {
                        final time = snapshot.data ?? widget.game.remainingTime ?? 0.0;
                        final minutes = (time / 60).floor();
                        final seconds = (time % 60).floor();
                        final timeStr = '$minutes:${seconds.toString().padLeft(2, '0')}';
                        
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Icon(
                              Icons.timer,
                              color: time < 10 ? Colors.red : const Color(0xFF2a9d8f),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              timeStr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: time < 10 ? Colors.red : const Color(0xFF2a9d8f),
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                if (widget.game.gameMode.durationSeconds != null) const Spacer(),
                // Progression Button
                _HUDButton(
                  icon: Icons.list_alt,
                  color: const Color(0xFFf4a261),
                  onPressed: () => _showProgressionDialog(context),
                ),
                const SizedBox(width: 12),
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
          ],
        ),
      ),
    );
  }

  void _showProgressionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fruit Evolution',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFe76f51),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              ProgressionBar(game: widget.game),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'GOT IT',
                  style: TextStyle(
                    color: Color(0xFF2a9d8f),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
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

  Stream<double?> _timerStream() async* {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) yield widget.game.remainingTime;
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