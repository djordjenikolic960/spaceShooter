import 'dart:math';
import 'package:first_game/game/enemy.dart';
import 'package:first_game/game/game.dart';
import 'package:first_game/game/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class EnemyManager extends Component with KnowsGameSize, HasGameRef<SpaceShooterGame> {
  late Timer _timer;
  SpriteSheet spriteSheet;
  Random random = Random();
  late Timer _freezeTimer;

  EnemyManager({required this.spriteSheet}) : super() {
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);
    _freezeTimer = Timer(2, onTick: () {
      _timer.start();
    });
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64,64);
    Vector2 position = Vector2(random.nextDouble() * gameSize.x, 0);

    position.clamp(Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);
    Enemy enemy = Enemy(
      sprite: gameRef.spriteSheet.getSpriteById(12),
      size: initialSize,
      position: position,
    );
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }

  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}