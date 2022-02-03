import 'dart:math';
import 'package:first_game/game/enemy.dart';
import 'package:first_game/game/game.dart';
import 'package:first_game/game/knows_game_size.dart';
import 'package:first_game/models/player_data.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:provider/provider.dart';

import '../models/enemy_data.dart';

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
    if (gameRef.buildContext != null) {
    int currentScore = Provider.of<PlayerData>(gameRef.buildContext!, listen: false).currentScore;
    int maxLevel = mapScoreToMaxEnemyLevel(currentScore);

    final enemyData = _enemyData.elementAt(random.nextInt(maxLevel * 4));
    Enemy enemy = Enemy(
        sprite: gameRef.spriteSheet.getSpriteById(enemyData.spriteId),
        size: initialSize,
        position: position,
        enemyData: enemyData
    );
    gameRef.add(enemy);
    }
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

  static const List<EnemyData> _enemyData = [
    EnemyData(
      killPoint: 1,
      speed: 200,
      spriteId: 8,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 2,
      speed: 200,
      spriteId: 9,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 4,
      speed: 200,
      spriteId: 10,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 4,
      speed: 200,
      spriteId: 11,
      level: 1,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 12,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 13,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 14,
      level: 2,
      hMove: false,
    ),
    EnemyData(
      killPoint: 6,
      speed: 250,
      spriteId: 15,
      level: 2,
      hMove: true,
    ),
    EnemyData(
      killPoint: 10,
      speed: 350,
      spriteId: 16,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 350,
      spriteId: 17,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 400,
      spriteId: 18,
      level: 3,
      hMove: true,
    ),
    EnemyData(
      killPoint: 10,
      speed: 400,
      spriteId: 19,
      level: 3,
      hMove: false,
    ),
    EnemyData(
      killPoint: 10,
      speed: 400,
      spriteId: 20,
      level: 4,
      hMove: false,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 21,
      level: 4,
      hMove: true,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 22,
      level: 4,
      hMove: false,
    ),
    EnemyData(
      killPoint: 50,
      speed: 250,
      spriteId: 23,
      level: 4,
      hMove: false,
    )
  ];

  int mapScoreToMaxEnemyLevel(int currentScore) {
    int level = 1;
    if(currentScore > 1500) {
      level = 4;
    } else if (currentScore > 500) {
      level = 3;
    } else if (currentScore > 100) {
      level  = 2;
    }
    return level;
  }
}