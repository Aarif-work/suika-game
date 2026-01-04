import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../game/constants.dart';

class AtmosphereBackground extends StatefulWidget {
  final GameTheme theme;

  const AtmosphereBackground({Key? key, required this.theme}) : super(key: key);

  @override
  State<AtmosphereBackground> createState() => _AtmosphereBackgroundState();
}

class _AtmosphereBackgroundState extends State<AtmosphereBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < 40; i++) {
      _particles.add(_createParticle());
    }
  }

  _Particle _createParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 20 + 5,
      speed: _random.nextDouble() * 0.001 + 0.0005,
      opacity: _random.nextDouble() * 0.3 + 0.1,
      angle: _random.nextDouble() * math.pi * 2,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.02,
      emoji: widget.theme == GameTheme.fruit 
        ? ['🍎', '🍒', '🍊', '🍇', '🍉', '🍍'][_random.nextInt(6)]
        : ['⭐', '✨', '☄️', '💫'][_random.nextInt(4)],
    );
  }

  @override
  void didUpdateWidget(AtmosphereBackground oldWidget) {
    if (oldWidget.theme != widget.theme) {
      _initParticles();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var particle in _particles) {
          particle.y += particle.speed;
          particle.angle += particle.rotationSpeed;
          if (particle.y > 1.0) {
            particle.y = -0.1;
            particle.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: _AtmospherePainter(
            particles: _particles,
            theme: widget.theme,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double angle;
  double rotationSpeed;
  String emoji;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
    required this.rotationSpeed,
    required this.emoji,
  });
}

class _AtmospherePainter extends CustomPainter {
  final List<_Particle> particles;
  final GameTheme theme;

  _AtmospherePainter({required this.particles, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var particle in particles) {
      final pos = Offset(particle.x * size.width, particle.y * size.height);
      
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(particle.angle);

      final style = TextStyle(
        fontSize: particle.size,
        color: Colors.white.withOpacity(particle.opacity),
      );

      textPainter.text = TextSpan(text: particle.emoji, style: style);
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
