import 'package:hive/hive.dart';

part 'spaceship_details.g.dart';

class Spaceship {
  final String name;
  final int cost;
  final double speed;
  final int spriteId;
  final String assetPath;
  final int level;

  const Spaceship(
      {required this.name,
      required this.cost,
      required this.speed,
      required this.spriteId,
      required this.assetPath,
      required this.level});

  static Spaceship getSpaceshipByType(SpaceshipType spaceshipType) {
    return spaceships[spaceshipType] ?? spaceships.entries.first.value;
  }

  static const Map<SpaceshipType, Spaceship> spaceships = {
    SpaceshipType.Canary: Spaceship(
      name: 'Canary',
      cost: 0,
      speed: 250,
      spriteId: 0,
      assetPath: 'assets/images/ship_A.png',
      level: 1,
    ),
    SpaceshipType.Dusky: Spaceship(
      name: 'Dusky',
      cost: 100,
      speed: 400,
      spriteId: 1,
      assetPath: 'assets/images/ship_B.png',
      level: 2,
    ),
    SpaceshipType.Condor: Spaceship(
      name: 'Condor',
      cost: 200,
      speed: 300,
      spriteId: 2,
      assetPath: 'assets/images/ship_C.png',
      level: 2,
    ),
    SpaceshipType.CXC: Spaceship(
      name: 'CXC',
      cost: 400,
      speed: 300,
      spriteId: 3,
      assetPath: 'assets/images/ship_D.png',
      level: 3,
    ),
    SpaceshipType.Raptor: Spaceship(
      name: 'Raptor',
      cost: 550,
      speed: 300,
      spriteId: 4,
      assetPath: 'assets/images/ship_E.png',
      level: 3,
    ),
    SpaceshipType.RaptorX: Spaceship(
      name: 'Raptor-X',
      cost: 700,
      speed: 350,
      spriteId: 5,
      assetPath: 'assets/images/ship_F.png',
      level: 3,
    ),
    SpaceshipType.Albatross: Spaceship(
      name: 'Albatross',
      cost: 850,
      speed: 400,
      spriteId: 6,
      assetPath: 'assets/images/ship_G.png',
      level: 4,
    ),
    SpaceshipType.DK809: Spaceship(
      name: 'DK-809',
      cost: 1000,
      speed: 450,
      spriteId: 7,
      assetPath: 'assets/images/ship_H.png',
      level: 4,
    )
  };
}

@HiveType(typeId: 1)
enum SpaceshipType {
  @HiveField(0)
  Canary,
  @HiveField(1)
  Dusky,
  @HiveField(2)
  Condor,
  @HiveField(3)
  CXC,
  @HiveField(4)
  Raptor,
  @HiveField(5)
  RaptorX,
  @HiveField(6)
  Albatross,
  @HiveField(7)
  DK809
}
