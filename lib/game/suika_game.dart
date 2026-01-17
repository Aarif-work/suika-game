import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'components/wall.dart';
import 'components/fruit.dart';
import 'components/merge_effect.dart';
import 'components/spawner.dart';
import 'components/deadline.dart';
import 'components/next_fruit_display.dart';
import 'components/score_display.dart';
import 'constants.dart';

class SuikaGame extends Forge2DGame with PanDetector, MouseMovementDetector {
  final GameMode _gameMode;
  final GameTheme _gameTheme;
  final bool _isInverted;

  GameMode get gameMode => _gameMode;
  GameTheme get gameTheme => _gameTheme;
  bool get isInverted => _isInverted;
  
  SuikaGame({
    GameMode? gameMode,
    GameTheme? gameTheme,
    bool isInverted = false,
  }) : _gameMode = gameMode ?? GameMode.classic,
       _gameTheme = gameTheme ?? GameTheme.fruit,
       _isInverted = isInverted,
       super(gravity: Vector2(0, isInverted ? -20 : 20));

  double? _remainingTime;
  double? get remainingTime => _remainingTime;
  double get ppm => camera.viewfinder.zoom;

  @override
  void onPanStart(DragStartInfo info) {
    _updatePointerPosition(info.eventPosition.widget);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _updatePointerPosition(info.eventPosition.widget);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!_canDrop || _currentFruitType == null) return;

    _canDrop = false;
    final position = _pointerPosition.clone();
    
    // Add tiny random jitter to prevent perfect "skyscraper" stacking
    final randomJitter = (Random().nextDouble() - 0.5) * 0.04; // +/- 0.02 meters
    position.x += randomJitter;
    
    // Create physical fruit directly
    final fruit = Fruit(_currentFruitType!, position);
    world.add(fruit);
    
    // Apply a tiny random nudge/impulse after a frame to ensure it's not perfectly static
    Future.microtask(() {
      if (fruit.isMounted && fruit.body.isActive) {
        final nudge = Vector2((Random().nextDouble() - 0.5) * 0.1, 0);
        fruit.body.applyLinearImpulse(nudge);
      }
    });

    _currentFruitType = null;

    // Delay before next spawn
    Future.delayed(const Duration(milliseconds: 500), () {
      _spawnNextFruit();
    });
  }

  void _updatePointerPosition(Vector2 widgetPosition) {
    // Standardized camera-based coordinate conversion
    final worldPosition = camera.globalToLocal(widgetPosition);
    double x = worldPosition.x;
    
    // Clamp to world boundaries with a small safety margin
    x = x.clamp(0.2, worldWidth - 0.2);
    _pointerPosition = Vector2(x, _isInverted ? worldHeight - 0.4 : 0.4);
  }

  // Queue for processing merges to avoid physics locking issues
  final List<({Fruit a, Fruit b})> _merges = [];

  @override
  Color backgroundColor() => Colors.transparent;


  // Input state
  late Vector2 _pointerPosition;
  FruitType? _currentFruitType;
  final List<FruitType> _nextFruitQueue = []; // Queue of next 3 fruits
  bool _canDrop = true;

  FruitType? get currentFruitType => _currentFruitType;
  List<FruitType> get nextFruitQueue => List.unmodifiable(_nextFruitQueue);
  Vector2 get pointerPosition => _pointerPosition;
  int get score => _score;

  int _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;
  bool _hasWon = false;
  
  int get highScore => _highScore;

  // Combo state
  int _comboCount = 0;
  double _lastMergeTime = 0;
  static const double comboWindow = 2.0; // Seconds

  @override
  void update(double dt) {
    if (_isGameOver) return;
    super.update(dt);

    if (_remainingTime != null) {
      _remainingTime = _remainingTime! - dt;
      if (_remainingTime! <= 0) {
        _remainingTime = 0;
        _gameOver();
      }
    }

    // Update combo expiration
    if (_comboCount > 0 && currentTime() - _lastMergeTime > comboWindow) {
      _comboCount = 0;
    }

    // 3️⃣ INVERTED MODE: Gravity curve
    if (_isInverted) {
      _applyInvertedGravityCurve();
    }

    // 5️⃣ ANTI-TOWER: Stack detection and drift
    _applyAntiTowerForces();

    _processMerges();
    _checkGameOver();
  }

  void _applyInvertedGravityCurve() {
    for (final child in world.children) {
      if (child is Fruit) {
        // Grav is stronger near the bottom (inverted ceiling)
        // Ceiling is at worldHeight, floor is at 0
        final distanceToCeiling = child.body.position.y; // 0 is top of screen (floor in inverted)
        // Normalize 0 to 1 where 0 is floor and 1 is ceiling
        final factor = (distanceToCeiling / worldHeight).clamp(0.0, 1.0);
        // We want stronger grav near the floor (y=0) because in inverted mode they fall UP
        // Wait, if _isInverted is true, gravity vector is (0, -20).
        // They fall towards y=0. So floor is y=7, ceiling is y=0.
        // Let's make it stronger near y=0.
        final curveFactor = 1.0 + (1.0 - factor) * 1.5; 
        child.body.applyForce(Vector2(0, -20 * curveFactor * child.body.mass));
      }
    }
  }

  void _applyAntiTowerForces() {
    final fruits = world.children.whereType<Fruit>().toList();
    for (int i = 0; i < fruits.length; i++) {
      final f1 = fruits[i];
      if (f1.timeAlive < 1.0) continue; // Let it settle first

      int stackHeight = 0;
      for (int j = 0; j < fruits.length; j++) {
        if (i == j) continue;
        final f2 = fruits[j];
        // If f1 is above f2 and they have similar X
        final isAbove = _isInverted ? (f1.body.position.y > f2.body.position.y) : (f1.body.position.y < f2.body.position.y);
        if (isAbove && (f1.body.position.x - f2.body.position.x).abs() < f1.type.radius * 0.5) {
          stackHeight++;
        }
      }

      if (stackHeight >= 2) {
        // Apply micro horizontal noise and torque reduction
        final driftDir = Random().nextBool() ? 1.0 : -1.0;
        f1.body.applyForce(Vector2(driftDir * 2.0 * stackHeight, 0));
        f1.body.angularVelocity *= 0.9; // Reduce spinning to stabilize
      }
    }
  }

  void onMerge(Fruit a, Fruit b) {
    if (a.isRemoved || b.isRemoved) return;
    _merges.add((a: a, b: b));
  }
  
  void _checkGameOver() {
    final deadlineY = _isInverted ? worldHeight - 0.8 : 0.8;
    
    for (final child in world.children) {
      if (child is Fruit) {
        // Game over if fruit stays beyond deadline for more than 1.5s
        if (_isInverted) {
          final fruitBottomY = child.body.position.y + child.type.radius;
          if (child.timeAlive > 1.5 && fruitBottomY > deadlineY) {
             _gameOver();
             return;
          }
        } else {
          final fruitTopY = child.body.position.y - child.type.radius;
          if (child.timeAlive > 1.5 && fruitTopY < deadlineY) {
             _gameOver();
             return;
          }
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
    
    pauseEngine();
    overlays.add('GameOver');
  }

  void _win() {
    _hasWon = true;
    _canDrop = false;

    // Update high score on win too
    if (_score > _highScore) {
      _highScore = _score;
    }

    pauseEngine();
    overlays.add('Win');
  }

  void resumeFromWin() {
    overlays.remove('Win');
    _canDrop = true;
    resumeEngine();
  }
  
  void reset() {
    // Remove all fruits
    final fruits = world.children.whereType<Fruit>().toList();
    for (final fruit in fruits) {
      world.remove(fruit);
    }
    
    _score = 0;
    _comboCount = 0;
    _isGameOver = false;
    _hasWon = false;
    _canDrop = true;
    _merges.clear();
    _remainingTime = gameMode.durationSeconds?.toDouble();
    _spawnNextFruit();
    
    overlays.remove('GameOver');
    resumeEngine();
  }

  // World dimensions in meters - responsive to screen
  static const double worldWidth = 5.0;
  static const double worldHeight = 7.0;
  // Scale factor (Pixels per Meter) - dynamic
  double _scale = 100.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    if (gameMode.durationSeconds != null) {
      _remainingTime = gameMode.durationSeconds!.toDouble();
    }
    
    _pointerPosition = Vector2(worldWidth / 2, _isInverted ? worldHeight - 0.4 : 0.4);

    // Initial fruit
    _spawnNextFruit();
    
    world.add(Spawner());
    world.add(Deadline());
    
    // HUD is handled by EnhancedHUD widget overlay in GameScreen

    // Setup Walls using world dimensions
    // Floor/Ceiling
    if (_isInverted) {
      await world.add(Wall(Vector2(0, 0), Vector2(worldWidth, 0))); // Ceiling (physical bottom)
    } else {
      await world.add(Wall(Vector2(0, worldHeight), Vector2(worldWidth, worldHeight))); // Floor
    }
    // Left Wall
    await world.add(Wall(Vector2(0, 0), Vector2(0, worldHeight)));
    // Right Wall
    await world.add(Wall(Vector2(worldWidth, 0), Vector2(worldWidth, worldHeight)));

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
    if (_nextFruitQueue.isEmpty) {
      for (int i = 0; i < 3; i++) {
        _nextFruitQueue.add(_generateRandomFruit());
      }
    }
    
    _currentFruitType = _nextFruitQueue.removeAt(0);
    _nextFruitQueue.add(_generateRandomFruit());
    _canDrop = true;
  }
  
  FruitType _generateRandomFruit() {
    return FruitType.values[Random().nextInt(4)];
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final worldPosition = camera.globalToLocal(info.eventPosition.widget);
    double x = worldPosition.x;
    x = x.clamp(0.2, worldWidth - 0.2);
    _pointerPosition = Vector2(x, _isInverted ? worldHeight - 0.4 : 0.4);
  }

  double currentTime() => DateTime.now().millisecondsSinceEpoch / 1000.0;

  void _processMerges() {
    final processed = <Fruit>{};
    for (final merge in _merges) {
      final a = merge.a;
      final b = merge.b;
      
      if (a.isRemoved || b.isRemoved) continue;
      if (processed.contains(a) || processed.contains(b)) continue;
      
      processed.add(a);
      processed.add(b);
      
      // 4️⃣ COMBO SYSTEM: Update combo state
      final combinedCurrentTime = currentTime();
      if (combinedCurrentTime - _lastMergeTime < comboWindow) {
        _comboCount++;
      } else {
        _comboCount = 1;
      }
      _lastMergeTime = combinedCurrentTime;

      // Multipliers: x1 → x1.5 → x2 → x3
      double multiplier = 1.0;
      if (_comboCount == 2) multiplier = 1.5;
      else if (_comboCount == 3) multiplier = 2.0;
      else if (_comboCount >= 4) multiplier = 3.0;

      // Camera Shake (using effects)
      camera.viewfinder.add(
        MoveByEffect(
          Vector2(0.035 * multiplier, 0.035 * multiplier),
          EffectController(duration: 0.05, reverseDuration: 0.05, repeatCount: 3),
        ),
      );

      // 2️⃣ FASTER GAMEPLAY: Post-merge pulse
      _triggerPostMergePulse(a.body.position, a.type.radius * 2);
      
      final midPoint = (a.body.position + b.body.position) / 2;
      
      // Add merge effect with combo info
      world.add(MergeEffect(
        fromType: a.type,
        toType: FruitType.values[a.type.index + 1],
        mergePosition: midPoint,
        multiplier: multiplier,
      ));
      
      world.remove(a);
      world.remove(b);
      
      final nextIndex = a.type.index + 1;
      if (nextIndex < FruitType.values.length) {
        final nextType = FruitType.values[nextIndex];
        world.add(Fruit(nextType, midPoint));
        _score += (nextType.score * multiplier).toInt();
        
        try {
          FlameAudio.play(nextType.audioFile);
        } catch (e) {}

        // Check for Win (Reached Max Fruit)
        if (nextIndex == FruitType.values.length - 1 && !_hasWon) {
          _win();
        }
      }
    }
    _merges.clear();
  }

  void _triggerPostMergePulse(Vector2 position, double radius) {
    for (final child in world.children) {
      if (child is Fruit) {
        final diff = child.body.position - position;
        final dist = diff.length;
        if (dist > 0 && dist < radius * 3) {
          diff.normalize();
          child.body.applyLinearImpulse(diff * (5.0 / (dist + 1)));
        }
      }
    }
  }
}
