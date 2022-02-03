import 'dart:math';
import 'package:first_game/game/bullet.dart';
import 'package:first_game/game/game.dart';
import 'package:first_game/game/player.dart';
import 'package:first_game/game/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../models/enemy_data.dart';
import 'audio_player_component.dart';
import 'command.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpaceShooterGame> {
  double _speed = 250;
  bool _isCollision = false;
  Random _random = Random();

  Vector2 moveDirection = Vector2(0,1);

  final EnemyData enemyData;

  int _hitPoints = 10;
  TextComponent _hpText = TextComponent(text: '10 HP',
  textRenderer: TextPaint(style: TextStyle(
      color: BasicPalette.white.color,
  fontSize: 12,
  fontFamily: 'BungeeInline')));

  late Timer _freezeTimer;

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  Enemy({
    required Sprite? sprite,
    required this.enemyData,
    required Vector2? position,
    required Vector2? size})
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center,
            angle: pi) {
    _speed = enemyData.speed;
    _hitPoints = enemyData.level * 10;
    _hpText.text = '$_hitPoints HP';
    if (enemyData.hMove) {
      moveDirection = getRandomDirection();
    }
    _freezeTimer = Timer(2, onTick: () {
      _speed = enemyData.speed;
    });

  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxPolygon([
      Vector2(0, 1), // Middle of top wall
      Vector2(1, 0), // Middle of right wall
      Vector2(0, -1), // Middle of bottom wall
      Vector2(-1, 0), // Middle of left wall
    ]));
  }

  @override
  void update(double dt) {
    if (_isCollision && _hitPoints == 0) {
      destroy();
      return;
    }
    _hpText.text = '$_hitPoints HP';
    _freezeTimer.update(dt);
    position += moveDirection * _speed * dt;
    _isCollision = false;
    if (position.y > gameSize.y) {
      removeFromParent();
    } else if ((position.x < size.x / 2) || (position.x > gameSize.x - size.x / 2)) {
      moveDirection.x *= -1;
    }
  }


  @override
  void onMount() {
    super.onMount();
    _hpText.angle = pi;
    _hpText.position = Vector2(50, 80);
    add(_hpText);
  }

  /* @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas);
  }
*/
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Bullet) {
      _hitPoints -= 5;
      _isCollision = true;
      return;
    } else if (other is Player) {
      _hitPoints = 0;
      _isCollision = true;
      return;
    }
  }

   destroy() {
    final command = Command<Player>(action: (player) {
      player.addToScore(enemyData.killPoint);
    });
    gameRef.addCommand(command);
    final particleComponent = ParticleComponent(Particle.generate(
        count: 20,
        lifespan: 0.1,
        generator: (index) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position,
          child: CircleParticle(
              paint: Paint()..color = Colors.white,
              radius: 1.5,
              lifespan: 1),
        )));
    gameRef.add(particleComponent);
    removeFromParent();
    gameRef.addCommand(Command<AudioPlayerComponent>(action: (audioPlayer) {
      audioPlayer.playSfx('laser1.ogg');
    }));
  }

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
