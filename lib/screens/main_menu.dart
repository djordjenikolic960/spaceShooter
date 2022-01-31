import 'package:first_game/screens/game_play.dart';
import 'package:first_game/screens/select_spaceship.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Spacescape',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    )
                  ]
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SelectSpaceship(),
                    ));
                  },
                  child: const Text('Play')),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    //navigate to options screen
                  },
                  child: const Text('Options')),
            )
          ],
        ),
      ),
    );
  }
}
