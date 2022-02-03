import 'package:first_game/game/game.dart';
import 'package:first_game/widgets/overlays/game_over.dart';
import 'package:first_game/widgets/overlays/pause_button.dart';
import 'package:first_game/widgets/overlays/pause_menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';



class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SpaceShooterGame _spaceShooterGame = SpaceShooterGame();
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async => false,
          child: GameWidget(
            game: _spaceShooterGame,
            initialActiveOverlays: [PauseButton.ID],
            overlayBuilderMap: {
              PauseButton.ID:
                  (BuildContext context, SpaceShooterGame gameRef) =>
                      PauseButton(gameRef: gameRef),
              PauseMenu.ID: (BuildContext context, SpaceShooterGame gameRef) =>
                  PauseMenu(gameRef: gameRef),
              GameOverMenu.ID: (BuildContext context, SpaceShooterGame gameRef) =>
                  GameOverMenu(gameRef: gameRef),
            },
          )),
    );
  }
}
