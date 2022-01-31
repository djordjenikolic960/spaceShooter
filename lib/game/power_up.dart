import 'package:first_game/game/enemy_manager.dart';
import 'package:first_game/game/game.dart';
import 'package:first_game/game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import 'command.dart';
import 'enemy.dart';

abstract class PowerUp extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, HasHitboxes, Collidable {
  late Timer _timer;

  Sprite getSprite();

  void onActivated();
  bool _isCollision = false;
  PowerUp({
    Vector2? position,
    Vector2? size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite) {
    _timer = Timer(3, onTick: () {
     // remove(this);
    });
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle(normalizedRadius: 0.5));
  }

  @override
  void update(double dt) {
    if (_isCollision) {
      _isCollision = false;
      onActivated();
      removeFromParent();
      return;
    }
    _timer.update(dt);
  }

  @override
  void onMount() {
   // _timer.start();
    this.sprite = getSprite();
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      _isCollision = true;
      return;
    }
  }
}

class Nuke extends PowerUp {
  Nuke({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('nuke.png'));
  }

  @override
  void onActivated() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.destroy();
    });
    gameRef.addCommand(command);
  }
}

class Health extends PowerUp {
  Health({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('icon_plus_small.png'));
  }

  @override
  void onActivated() {
    final command = Command<Player>(action: (player) {
     player.increaseHealthBy(10);
    });
    gameRef.addCommand(command);
  }
}

class Freeze extends PowerUp {
  Freeze({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('freeze.png'));
  }

  @override
  void onActivated() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.freeze();
    });
    gameRef.addCommand(command);

    final commandManager = Command<EnemyManager>(action: (enemyManager) {
      enemyManager.freeze();
    });
    gameRef.addCommand(commandManager);
  }
}

class MultiFire extends PowerUp {
  MultiFire({Vector2? position, Vector2? size})
      : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('multi_fire.png'));
  }

  @override
  void onActivated() {
    final command = Command<Player>(action: (player) {
      player.shootMultipleBullets();
    });
    gameRef.addCommand(command);
  }
}
