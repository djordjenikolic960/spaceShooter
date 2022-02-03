import 'package:first_game/game/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Bullet extends SpriteComponent with HasHitboxes, Collidable {
  final double _speed = 450;
  bool _isCollision = false;
  Vector2 direction = Vector2(0, -1);
  final int level;

  Bullet(
      {required Sprite? sprite,
      required Vector2? position,
      required Vector2? size,
      required this.level})
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxCircle(normalizedRadius: 0.4));
  }

  @override
  void update(double dt) {
    if (_isCollision) {
      removeFromParent();
      return;
    }
    position += direction * _speed * dt;
    _isCollision = false;
  }

  /* @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas);
  }*/

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy) {
      _isCollision = true;
      return;
    }
  }
}
