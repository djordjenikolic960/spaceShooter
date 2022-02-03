import 'package:flame/components.dart';

mixin KnowsGameSize on Component {
  Vector2 gameSize = Vector2(400,700);

  void onResize(Vector2 newGameSize) {
    gameSize = newGameSize;
  }
}