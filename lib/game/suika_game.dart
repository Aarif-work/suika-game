import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'dart:ui'; // For Canvas
import 'components/wall.dart';
import 'components/fruit.dart';
import 'components/spawner.dart';
import 'components/next_fruit_display.dart';
import 'components/score_display.dart';
import 'logic/fruit_manager.dart';
import 'constants.dart';

class SuikaGame extends Forge2DGame with TapCallbacks, MouseMovementDetector {

  // Queue for processing merges to avoid physics locking issues
  final List<({Fruit a, Fruit b})> _merges = [];

  SuikaGame()
      : super(
          gravity: Vector2(0, 20),
        );

  // Input state
  Vector2 _pointerPosition = Vector2(3.0, 1.0); // Start at center (approx)
  FruitType? _currentFruitType;
  FruitType _nextFruitType = FruitType.cherry;
  bool _canDrop = true;

  FruitType? get currentFruitType => _currentFruitType;
  FruitType get nextFruitType => _nextFruitType;
  Vector2 get pointerPosition => _pointerPosition;
  int get score => _score;

  int _score = 0;
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
    for (final child in world.children) {
      if (child is Fruit) {
        // If fruit is above the line (y < 1.0) and alive for > 2s
        if (child.timeAlive > 2.0 && child.body.position.y < 1.0) {
           _gameOver();
           return;
        }
      }
    }
  }
  
  void _gameOver() {
    _isGameOver = true;
    _canDrop = false;
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


  // World dimensions in meters
  static const double worldWidth = 6.0;
  static const double worldHeight = 9.0;
  // Scale factor (Pixels per Meter) - dynamic
  double _scale = 100.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initial fruit
    _spawnNextFruit();
    
    world.add(Spawner());
    
    camera.viewport.add(NextFruitDisplay());
    camera.viewport.add(ScoreDisplay());

    // Setup Walls using world dimensions
    // Floor
    await world.add(Wall(Vector2(0, worldHeight), Vector2(worldWidth, worldHeight)));
    // Left Wall
    await world.add(Wall(Vector2(0, 0), Vector2(0, worldHeight)));
    // Right Wall
    await world.add(Wall(Vector2(worldWidth, 0), Vector2(worldWidth, worldHeight)));

    // Camera setup will be handled in onGameResize initially called by engine? 
    // Or we force it here partially.
    camera.viewfinder.anchor = Anchor.center;
  }
  
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    
    // Calculate scale to fit worldWidth/Height into size with padding?
    // Let's maximize zoom such that it fits.
    // scaleX = size.x / worldWidth
    // scaleY = size.y / worldHeight
    
    final scaleX = size.x / worldWidth;
    final scaleY = size.y / worldHeight;
    
    // Use the smaller scale to ensure it fits entirely
    _scale = (scaleX < scaleY) ? scaleX : scaleY;
    
    // Apply zoom
    camera.viewfinder.zoom = _scale;
    
    // Center camera on the world center
    camera.viewfinder.position = Vector2(worldWidth / 2, worldHeight / 2);
  }

  void _spawnNextFruit() {
    _currentFruitType = _nextFruitType;
    final nextIndex = (DateTime.now().millisecondsSinceEpoch % 3);
    _nextFruitType = FruitType.values[nextIndex];
    _canDrop = true;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.widget;
    
    // Use dynamic scale
    double x = screenPosition.x / _scale;
    
    // Clamp to walls
    x = x.clamp(0.2, worldWidth - 0.2);
    
    _pointerPosition = Vector2(x, 1.0);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_canDrop || _currentFruitType == null) return;
    
    // Update position from tap event for robustness
    double x = event.devicePosition.x / _scale;
    x = x.clamp(0.2, worldWidth - 0.2);
    _pointerPosition = Vector2(x, 1.0);

    _canDrop = false;
    final position = _pointerPosition.clone();
    
    // Create physical fruit
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
    
    // Render current fruit (Spawner)
    if (_currentFruitType != null) {
      // We need to render this in world space.
      // Super.render renders the world via camera.
      // If we render here, we are drawing on top of the generic canvas (screen space?) OR world space?
      // Forge2DGame.render calls super.render which renders components.
      // If we want to draw in world space, we should add a component.
    }
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
      
      // Remove old fruits
      world.remove(a);
      world.remove(b);
      
      // Spawn next tier
      final nextIndex = a.type.index + 1;
      if (nextIndex < FruitType.values.length) {
        final nextType = FruitType.values[nextIndex];
        world.add(Fruit(nextType, midPoint));
        _score += nextType.score;
      }
    }
    _merges.clear();
  }


}
