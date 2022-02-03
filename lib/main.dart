import 'package:first_game/models/player_data.dart';
import 'package:first_game/models/spaceship_details.dart';
import 'package:first_game/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await initHive();
  runApp(
    MultiProvider(
      providers: [
        FutureProvider<PlayerData>(
          create: (BuildContext context) => getPlayerData(),
          initialData: PlayerData.fromMap(PlayerData.defaultData),
        ),
        FutureProvider<Settings>(
          create: (BuildContext context) => getSettings(),
          initialData: Settings(soundEffects: false, backgroundMusic: false),
        ),
      ],
      builder: (context, child) {
        // We use .value constructor here because the required objects
        // are already created by upstream FutureProviders.
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<PlayerData>.value(
              value: Provider.of<PlayerData>(context),
            ),
            ChangeNotifierProvider<Settings>.value(
              value: Provider.of<Settings>(context),
            ),
          ],
          child: child,
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Dark more because we are too cool for white theme.
        themeMode: ThemeMode.dark,
        // Use custom theme with 'BungeeInline' font.
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'BungeeInline',
          scaffoldBackgroundColor: Colors.black,
        ),
        // MainMenu will be the first screen for now.
        // But this might change in future if we decide
        // to add a splash screen.
        home: const MainMenu(),
      ),
    ),
  );
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SpaceshipTypeAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

Future<PlayerData> getPlayerData() async {
  final box = await Hive.openBox<PlayerData>(PlayerData.PLAYER_DATA_BOX);
  final playerData = box.get(PlayerData.PLAYER_DATA_KEY);
  if (playerData == null) {
    box.put(
        PlayerData.PLAYER_DATA_KEY, PlayerData.fromMap(PlayerData.defaultData));
  }
  return box.get(PlayerData.PLAYER_DATA_KEY)!;
}

Future<Settings> getSettings() async {
  final box = await Hive.openBox<Settings>(Settings.SETTINGS_BOX);
  final settings = box.get(Settings.SETTINGS_KEY);
  if (settings == null) {
    box.put(Settings.SETTINGS_KEY,
        Settings(soundEffects: true, backgroundMusic: true));
  }
  return box.get(Settings.SETTINGS_KEY)!;
}
