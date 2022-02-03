import 'package:first_game/game/game.dart';
import 'package:first_game/widgets/overlays/pause_menu.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  static const String ID = 'PauseButton';
  final SpaceShooterGame gameRef;

  const PauseButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
        onPressed: () {
          gameRef.pauseEngine();
          gameRef.overlays.add(PauseMenu.ID);
          gameRef.overlays.remove(PauseButton.ID);
        },
        child: const Icon(Icons.pause_rounded, color: Colors.white),
      ),
    );
  }
}
