import 'dart:math';

import 'package:first_game/game/command.dart';
import 'package:first_game/game/enemy_manager.dart';
import 'package:first_game/game/knows_game_size.dart';
import 'package:first_game/game/power_up.dart';
import 'package:first_game/models/player_data.dart';
import 'package:first_game/models/spaceship_details.dart';
import 'package:first_game/widgets/overlays/game_over.dart';
import 'package:first_game/widgets/overlays/pause_button.dart';
import 'package:first_game/widgets/overlays/pause_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bullet.dart';
import 'enemy.dart';
import 'player.dart';

class SpaceShooterGame extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  // late Player player;
  late EnemyManager _enemyManager;
  late SpriteSheet spriteSheet;
  late SpriteSheet myPlane;

  late final Player _player;
  late final JoystickComponent joystick;

  late TextComponent playerScore;
  late TextComponent playerHealth;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  @override
  Future<void>? onLoad() async {
    if (!_isAlreadyLoaded) {
      await images.loadAll([
        'simple_space.png',
        'freeze.png',
        'multi_fire.png',
        'nuke.png',
        'icon_plus_small.png'
      ]);

      spriteSheet = SpriteSheet.fromColumnsAndRows(
          image: images.fromCache('simple_space.png'), columns: 8, rows: 6);

      final knobPaint = BasicPalette.blue.withAlpha(200).paint();
      final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

      _enemyManager = EnemyManager(spriteSheet: spriteSheet);
      add(_enemyManager);

      joystick = JoystickComponent(
          knob: CircleComponent(radius: 20, paint: knobPaint),
          background: CircleComponent(radius: 50, paint: backgroundPaint),
          margin: const EdgeInsets.only(left: 40, bottom: 50),
          position: Vector2(200, 200));

      final spaceType = SpaceshipType.Canary;
      final spaceShip = Spaceship.getSpaceshipByType(spaceType);

         _player = Player(
          joystick: joystick,
          sprite: spriteSheet.getSpriteById(spaceShip.spriteId),
          spaceshipType: spaceType);

      final fireButton = HudButtonComponent(
        position: Vector2(300, 100),
        button: CircleComponent(
          paint: backgroundPaint,
          radius: 30,
        ),
        buttonDown: CircleComponent(
          paint: backgroundPaint,
          radius: 30,
        ),
        margin: const EdgeInsets.only(right: 40, bottom: 50),
        onPressed: () => {fireBullet()},
      );

      add(_player);
      add(joystick);
      add(fireButton);
      final style = TextStyle(color: BasicPalette.white.color);
      final regular = TextPaint(style: style);
      playerScore = TextComponent(
          text: 'Score: 0', position: Vector2(10, 10), textRenderer: regular);
      add(playerScore);

      playerHealth = TextComponent(
          text: 'Health: 100%',
          position: Vector2(size.x - 10, 10),
          textRenderer: regular,
          anchor: Anchor.topRight);
      add(playerHealth);
      final nuke =
          Nuke(position: (size / 2) + Vector2(0, 150), size: Vector2(64, 64));
      add(nuke);
      final health = Health(
          position: (size / 2) + Vector2(0, -150), size: Vector2(64, 64));
      add(health);
      final freeze = Freeze(
          position: (size / 2) + Vector2(100, 100), size: Vector2(64, 64));
      add(freeze);
      final multiFire = MultiFire(
          position: (size / 2) + Vector2(-100, 100), size: Vector2(64, 64));
      add(multiFire);
      _isAlreadyLoaded = true;
    }
  }

  //buildContext moze da se dobije u on attach, ali ne i u on load
  @override
  void onAttach() {
    if (buildContext != null) {
      final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
      _player.setSpaceshipType(playerData.spaceshipType);
    }
    super.onAttach();
  }

  @override
  void prepare(Component parent) {
    super.prepare(parent);
    if (parent is KnowsGameSize) {
      parent.onResize(size);
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    children.whereType<KnowsGameSize>().forEach((element) {
      element.onResize(size);
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var command in _commandList) {
      for (var child in children) {
        command.run(child);
      }
    }

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    playerScore.text = 'Score: ${_player.getScore()}';
    playerHealth.text = 'Health: ${_player.getHealth()} %';

    if (_player.getHealth() <= 0 && !camera.shaking) {
      pauseEngine();
      overlays.remove(PauseButton.ID);
      overlays.add(GameOverMenu.ID);
    }
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_player.getHealth() > 0) {
          pauseEngine();
          overlays.remove(PauseButton.ID);
          overlays.add(PauseMenu.ID);
        }
        break;
    }
    super.lifecycleStateChange(state);
  }

  fireBullet() {
    if (_player.getIsShootMultipleBullets()) {
      for (int i = -1; i < 2; i += 2) {
        Bullet bullet = Bullet(
          sprite: spriteSheet.getSpriteById(28),
          size: Vector2(64, 64),
          position: _player.position.clone(),
        );
        bullet.direction.rotate(i * pi / 6);
        add(bullet);
      }
    }
    Bullet bullet = Bullet(
      sprite: spriteSheet.getSpriteById(28),
      size: Vector2(64, 64),
      position: _player.position.clone(),
    );
    add(bullet);
  }

  destroyAll() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.destroy();
    });
    addCommand(command);
  }

  void reset() {
    _player.reset();
    _enemyManager.reset();
    children.whereType<Enemy>().forEach((element) {
      element.removeFromParent();
    });
    children.whereType<Bullet>().forEach((element) {
      element.removeFromParent();
    });
  }
}
