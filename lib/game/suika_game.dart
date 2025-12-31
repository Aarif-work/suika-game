import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'components/wall.dart';
import 'components/fruit.dart';
import 'components/merge_effect.dart';
import 'components/spawner.dart';
import 'components/next_fruit_display.dart';
import 'components/score_display.dart';
import 'constants.dart';

class SuikaGame extends Forge2DGame with TapCallbacks, MouseMovementDetector {

  // Queue for processing merges to avoid physics locking issues
  final List<({Fruit a, Fruit b})> _merges = [];

  SuikaGame()
      : super(
          gravity: Vector2(0, 20),
        );

  // Input state
  Vector2 _pointerPosition = Vector2(3.0, 1.0);
  FruitType? _currentFruitType;
  final List<FruitType> _nextFruitQueue = []; // Queue of next 3 fruits
  bool _canDrop = true;

  FruitType? get currentFruitType => _currentFruitType;
  List<FruitType> get nextFruitQueue => List.unmodifiable(_nextFruitQueue);
  Vector2 get pointerPosition => _pointerPosition;
  int get score => _score;

  int _score = 0;
  int _highScore = 0;
  
  int get highScore => _highScore;
  bool _isGameOver = false;

  @override
  void update(double dt) {
    if (_isGameOver) return;
    super.update(dt);
    _processMerges();
    _checkGameOver();
  }

  void onMerge(Fruit a, Fruit b) {
    if (a.isRemoved || b.isRemoved) return;
    _merges.add((a: a, b: b));
  }
  
  void _checkGameOver() {
    const deadlineY = 0.8; // Deadline line near top
    
    for (final child in world.children) {
      if (child is Fruit) {
        // If fruit is above the deadline line and alive for > 2s
        if (child.timeAlive > 2.0 && child.body.position.y < deadlineY) {
           _gameOver();
           return;
        }
      }
    }
  }
  
  void _gameOver() {
    _isGameOver = true;
    _canDrop = false;
    
    // Update high score
    if (_score > _highScore) {
      _highScore = _score;
    }
    
    // Print final score to console
    print('========================================');
    print('GAME OVER!');
    print('Final Score: $_score');
    print('High Score: $_highScore');
    print('========================================');
    
    pauseEngine();
    overlays.add('GameOver');
  }
  
  void reset() {
    // Remove all fruits
    final fruits = world.children.whereType<Fruit>().toList();
    for (final fruit in fruits) {
      world.remove(fruit);
    }
    
    _score = 0;
    _isGameOver = false;
    _canDrop = true;
    _spawnNextFruit();
    
    overlays.remove('GameOver');
    resumeEngine();
  }

  // ... merge logic ...


  // World dimensions in meters - responsive to screen
  static const double worldWidth = 5.0;
  static const double worldHeight = 7.0;
  // Scale factor (Pixels per Meter) - dynamic
  double _scale = 100.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initial fruit
    _spawnNextFruit();
    
    world.add(Spawner());
    
    // HUD is handled by EnhancedHUD widget overlay in GameScreen
    // camera.viewport.add(NextFruitDisplay());
    // camera.viewport.add(ScoreDisplay());

    // Setup Walls using world dimensions
    // Floor
    await world.add(Wall(Vector2(0, worldHeight), Vector2(worldWidth, worldHeight)));
    // Left Wall
    await world.add(Wall(Vector2(0, 0), Vector2(0, worldHeight)));
    // Right Wall
    await world.add(Wall(Vector2(worldWidth, 0), Vector2(worldWidth, worldHeight)));

    // Camera setup will be handled in onGameResize initially called by engine? 
    // Or we force it here partially.
    // Pre-load audio
    try {
      await FlameAudio.audioCache.loadAll([
        ...FruitType.values.map((f) => f.audioFile),
      ]);
    } catch (e) {
      // Audio loading failed
    }

    camera.viewfinder.anchor = Anchor.center;
  }
  
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    
    final scaleX = size.x / worldWidth;
    final scaleY = size.y / worldHeight;
    
    _scale = (scaleX < scaleY) ? scaleX : scaleY;
    
    camera.viewfinder.zoom = _scale;
    
    camera.viewfinder.position = Vector2(worldWidth / 2, worldHeight / 2);
  }

  void _spawnNextFruit() {
    // Initialize queue if empty
    if (_nextFruitQueue.isEmpty) {
      for (int i = 0; i < 3; i++) {
        _nextFruitQueue.add(_generateRandomFruit());
      }
    }
    
    // Take first fruit from queue
    _currentFruitType = _nextFruitQueue.removeAt(0);
    
    // Add new fruit to end of queue
    _nextFruitQueue.add(_generateRandomFruit());
    
    _canDrop = true;
  }
  
  FruitType _generateRandomFruit() {
    final nextIndex = (DateTime.now().millisecondsSinceEpoch % 3);
    return FruitType.values[nextIndex];
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.widget;
    
    double x = screenPosition.x / _scale;
    
    x = x.clamp(0.2, worldWidth - 0.2);
    
    _pointerPosition = Vector2(x, 1.0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_canDrop || _currentFruitType == null) return;

    // Update position from tap event
    double x = event.devicePosition.x / _scale;
    x = x.clamp(0.2, worldWidth - 0.2);
    _pointerPosition = Vector2(x, 1.0);

    _canDrop = false;
    final position = _pointerPosition.clone();
    
    // Create physical fruit directly
    world.add(Fruit(_currentFruitType!, position));
    _currentFruitType = null;

    // Delay before next spawn
    Future.delayed(const Duration(milliseconds: 500), () {
      _spawnNextFruit();
    });
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw deadline line (game over line) - very visible at top
    const deadlineY = 0.8;
    
    // Red danger line
    final linePaint = Paint()
      ..color = const Color(0xFFff0000)
      ..strokeWidth = 0.1
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      const Offset(0, deadlineY),
      Offset(worldWidth, deadlineY),
      linePaint,
    );
    
    // Yellow warning stripes above the line
    final stripePaint = Paint()
      ..color = const Color(0xFFffff00).withOpacity(0.7)
      ..strokeWidth = 0.06;
    
    const stripeWidth = 0.3;
    const stripeSpace = 0.3;
    double startX = 0.0;
    
    while (startX < worldWidth) {
      canvas.drawLine(
        Offset(startX, deadlineY - 0.08),
        Offset((startX + stripeWidth).clamp(0, worldWidth), deadlineY - 0.08),
        stripePaint,
      );
      startX += stripeWidth + stripeSpace;
    }
    
    // Draw "DANGER" label
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'DANGER ZONE',
        style: TextStyle(
          fontSize: 0.15,
          fontWeight: FontWeight.bold,
          color: Color(0xFFff0000),
          letterSpacing: 0.02,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((worldWidth - textPainter.width) / 2, deadlineY - 0.35),
    );
  }

  void _processMerges() {
    final processed = <Fruit>{};
    for (final merge in _merges) {
      final a = merge.a;
      final b = merge.b;
      
      if (a.isRemoved || b.isRemoved) continue;
      if (processed.contains(a) || processed.contains(b)) continue;
      
      processed.add(a);
      processed.add(b);
      
      // Calculate midpoint
      final midPoint = (a.body.position + b.body.position) / 2;
      
      // Add merge effect
      world.add(MergeEffect(
        fromType: a.type,
        toType: FruitType.values[a.type.index + 1],
        mergePosition: midPoint,
      ));
      
      // Remove old fruits
      world.remove(a);
      world.remove(b);
      
      // Spawn next tier
      final nextIndex = a.type.index + 1;
      if (nextIndex < FruitType.values.length) {
        final nextType = FruitType.values[nextIndex];
        world.add(Fruit(nextType, midPoint));
        _score += nextType.score;
        
        // Play merge sound
        try {
          FlameAudio.play(nextType.audioFile);
        } catch (e) {
          // Audio playback failed
        }
      }
    }
    _merges.clear();
  }


}
