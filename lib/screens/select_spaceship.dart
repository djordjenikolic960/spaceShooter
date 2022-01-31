import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_game/models/player_data.dart';
import 'package:first_game/models/spaceship_details.dart';
import 'package:first_game/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_play.dart';

class SelectSpaceship extends StatelessWidget {
  const SelectSpaceship({Key? key}) : super(key: key);

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
                'Select',
                style: TextStyle(color: Colors.black, fontSize: 50, shadows: [
                  Shadow(
                    blurRadius: 20,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ]),
              ),
            ),
            Consumer<PlayerData>(
              builder: (context, playerData, child) {
                final spaceship =
                    Spaceship.getSpaceshipByType(playerData.spaceshipType);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Ship: ${spaceship.name}'),
                    Text('Money: ${playerData.money}')
                  ],
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CarouselSlider.builder(
                  itemCount: Spaceship.spaceships.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Spaceship.spaceships.entries
                                .elementAt(itemIndex)
                                .value
                                .assetPath,
                            height: 100,
                          ),
                          Text('Speed: ${Spaceship.spaceships.entries
                              .elementAt(itemIndex)
                              .value
                              .speed
                              .toString()}'),
                          Text('Level: ${Spaceship.spaceships.entries
                              .elementAt(itemIndex)
                              .value
                              .level
                              .toString()}'),
                          Text('Cost: ${Spaceship.spaceships.entries
                              .elementAt(itemIndex)
                              .value
                              .cost
                              .toString()}'),
                          Consumer<PlayerData>(
                              builder: (context, playerData, child) {
                            final type = Spaceship.spaceships.entries
                                .elementAt(itemIndex)
                                .key;
                            final isEquipped = playerData.isEquipped(type);
                            final isOwned = playerData.isOwned(type);
                            final canBuy = playerData.canBuy(type);
                            return ElevatedButton(
                                onPressed: isEquipped
                                    ? null
                                    : () {
                                        if (isOwned) {
                                          playerData.equip(type);
                                        } else {
                                          if (canBuy) {
                                            playerData.buy(type);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.red,
                                                    title: const Text(
                                                        'Insufficient Balance'),
                                                    content: Text(
                                                        'Need ${Spaceship.spaceships.entries.elementAt(itemIndex).value.cost - playerData.money} more',
                                                        textAlign:
                                                            TextAlign.center),
                                                  );
                                                });
                                          }
                                        }
                                      },
                                child: Text(isEquipped
                                    ? 'Equipped'
                                    : isOwned
                                        ? 'Select'
                                        : 'Buy'));
                          }),
                        ],
                      ),
                  options: CarouselOptions()),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamePlay(),
                    ));
                  },
                  child: const Text('Start')),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MainMenu(),
                    ));
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded)),
            )
          ],
        ),
      ),
    );
  }
}
