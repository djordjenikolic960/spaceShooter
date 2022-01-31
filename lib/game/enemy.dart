import 'dart:math';
import 'package:first_game/game/bullet.dart';
import 'package:first_game/game/game.dart';
import 'package:first_game/game/player.dart';
import 'package:first_game/game/knows_game_size.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import 'command.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpaceShooterGame> {
  double _speed = 250;
  bool _isCollision = false;
  Random _random = Random();

  late Timer _freezeTimer;

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Enemy({Sprite? sprite, Vector2? position, Vector2? size})
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center,
            angle: pi) {
    _freezeTimer = Timer(2, onTick: () {
      _speed = 250;
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
    if (_isCollision) {
      destroy();
      return;
    }
    _freezeTimer.update(dt);
    position += Vector2(0, 1) * _speed * dt;
    _isCollision = false;
  }

 /* @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas);
  }
*/
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Bullet || other is Player) {
      _isCollision = true;
      return;
    }
  }

   destroy() {
    final command = Command<Player>(action: (player) {
      player.addToScore(1);
    });
    gameRef.addCommand(command);
    // gameRef.player.score += 1;
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
  }

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
