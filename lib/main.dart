import 'package:first_game/models/player_data.dart';
import 'package:first_game/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
      ChangeNotifierProvider(
      create: (context) => PlayerData.fromMap(PlayerData.defaultData),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'BungeeInline',
            scaffoldBackgroundColor: Colors.black),
        home: const MainMenu(),
      )));
}
