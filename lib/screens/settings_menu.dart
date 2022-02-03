import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

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
                'Settings',
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
         
            Selector<Settings, bool>(
                selector: (context, settings) => settings.soundEffects,
                builder: (context, value, child) {
                  return SwitchListTile(
                      title: const Text('Sound Effects'),
                      value: value, onChanged: (newValue) {
                 Provider.of<Settings>(context, listen: false).soundEffects = newValue;

                  });
                }),

            Selector<Settings, bool>(
                selector: (context, settings) => settings.backgroundMusic,
                builder: (context, value, child) {
                  return SwitchListTile(
                      title: const Text('Background Music'),
                      value: value, onChanged: (newValue) {
                    Provider.of<Settings>(context, listen: false).backgroundMusic = newValue;

                  });
                }),
            
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded)),
            )
          ],
        ),
      ),
    );
  }
}
