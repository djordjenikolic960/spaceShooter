import 'package:first_game/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';

class AudioPlayerComponent extends Component with HasGameRef<SpaceShooterGame> {

  @override
  Future<void>? onLoad() {
    FlameAudio.bgm.initialize();

    FlameAudio.audioCache.loadAll([
      'laser1.ogg',
      'laserSmall_001.ogg',
      '9. Space Invaders.wav'
    ]);
    return super.onLoad();
  }

  void playBgm(String fileName) {
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false).backgroundMusic) {
        FlameAudio.bgm.play(fileName);
      }
    }
  }

  void playSfx(String fileName) {
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false).soundEffects) {
        FlameAudio.play(fileName);
      }
    }

  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}