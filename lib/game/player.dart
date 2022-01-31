import 'dart:math';
import 'package:first_game/game/game.dart';
import 'package:first_game/models/player_data.dart';
import 'package:first_game/models/spaceship_details.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enemy.dart';
import 'knows_game_size.dart';

class Player extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, KnowsGameSize, HasHitboxes, Collidable {

  int _score = 0;
  int _health = 100;

  int getHealth() => _health;

  int getScore() => _score;

  bool _isCollision = false;

  final JoystickComponent joystick;

  SpaceshipType spaceshipType;
  Spaceship _spaceship;

  late PlayerData _pLayerData;

  bool _shootMultipleBullets = false;

  bool getIsShootMultipleBullets() => _shootMultipleBullets;
  Random _random = Random();

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -1)) * 200;
  }

  Player(
      {required this.joystick,
      required Sprite sprite,
      required this.spaceshipType})
      : _spaceship = Spaceship.getSpaceshipByType(spaceshipType),
        super(
          sprite: sprite,
          size: Vector2(64, 64),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = gameRef.size / 2;
    addHitbox(HitboxCircle(normalizedRadius: 0.8));
  }

  @override
  void update(double dt) {
    if (_isCollision) {
      gameRef.camera.shake(duration: 0.1, intensity: 20);
      _health -= 5;
      if (_health <= 0) {
        _health = 0;
      }
      _isCollision = false;
      return;
    }
    _isCollision = false;
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * _spaceship.speed * dt);
      position.clamp(Vector2.zero() + size / 2, gameSize - size / 2);
    }
    final particleComponent = ParticleComponent(Particle.generate(
        count: 5,
        lifespan: 0.1,
        generator: (index) => AcceleratedParticle(
              acceleration: getRandomVector(),
              speed: getRandomVector(),
              position: (position + Vector2(0, 25)),
              child: CircleParticle(
                  paint: Paint()..color = Colors.redAccent,
                  radius: 1,
                  lifespan: 1),
            )));
    gameRef.add(particleComponent);
    _pLayerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {
      _isCollision = true;
      if (_shootMultipleBullets) {
        _shootMultipleBullets = false;
      }
      return;
    }
  }

  void addToScore(int points) {
    _score += points;
    _pLayerData.money += points;
  }

  void reset() {
    _score = 0;
    _health = 100;
    position = gameRef.size / 2;
  }

  void setSpaceshipType(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    _spaceship = Spaceship.getSpaceshipByType(spaceshipType);
    sprite = gameRef.spriteSheet.getSpriteById(_spaceship.spriteId);
  }

  void increaseHealthBy(int health) {
    _health += health;
    if (_health > 100) {
      _health = 100;
    }
  }

  void shootMultipleBullets() {
    _shootMultipleBullets = true;
  }
}
