import 'package:first_game/game/game.dart';
import 'package:first_game/screens/main_menu.dart';
import 'package:flutter/material.dart';

import 'pause_button.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final SpaceShooterGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Text(
              'Paused',
              style: TextStyle(color: Colors.black, fontSize: 50, shadows: [
                Shadow(
                  blurRadius: 20,
                  color: Colors.white,
                  offset: Offset(0, 0),
                )
              ]),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  gameRef.resumeEngine();
                  gameRef.overlays.remove(PauseMenu.ID);
                  gameRef.overlays.add(PauseButton.ID);
                },
                child: const Text('Resume')),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.add(PauseButton.ID);
                  gameRef.overlays.remove(PauseMenu.ID);
                  gameRef.reset();
                  gameRef.resumeEngine();
                },
                child: const Text('Restart')),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(PauseMenu.ID);
                  gameRef.reset();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ));
                  //navigate to options screen
                },
                child: const Text('Exit')),
          ),
        ],
      ),
    );
  }
}
