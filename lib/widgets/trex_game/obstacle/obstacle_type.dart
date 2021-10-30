import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../collision/collision_box.dart';

class ObstacleType {
  const ObstacleType._internal(
    this.type, {
    required this.spriteWidth,
    required this.spriteHeight,
    required this.width,
    required this.height,
    required this.minGap,
    this.numFrames,
    this.frameRate,
    this.speedOffset,
    required this.collisionBoxes,
  });

  final String type;
  final double spriteWidth;
  final double spriteHeight;
  final double width;
  final double height;
  final double minGap;
  final int? numFrames;
  final double? frameRate;
  final double? speedOffset;

  final List<CollisionBox> collisionBoxes;

  static final cactusSmall = ObstacleType._internal(
    "cactusSmall",
    spriteWidth: 34.0,
    spriteHeight: 70.0,
    width: 17.0,
    height: 35.0,
    minGap: 120.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(
        position: Vector2(5.0, 7.0),
        size: Vector2(10.0, 54.0),
      ),
      CollisionBox(
        position: Vector2(5.0, 7.0),
        size: Vector2(12.0, 68.0),
      ),
      CollisionBox(
        position: Vector2(15.0, 4.0),
        size: Vector2(14.0, 28.0),
      ),
    ],
  );

  static final cactusLarge = ObstacleType._internal(
    "cactusLarge",
    spriteWidth: 50.0,
    spriteHeight: 100.0,
    width: 25.0,
    height: 50.0,
    minGap: 150.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(
        position: Vector2(0.0, 12.0),
        size: Vector2(14.0, 76.0),
      ),
      CollisionBox(
        position: Vector2(8.0, 0.0),
        size: Vector2(14.0, 98.0),
      ),
      CollisionBox(
        position: Vector2(13.0, 10.0),
        size: Vector2(20.0, 76.0),
      )
    ],
  );

  Sprite getSprite(Image spriteImage) {
    if (this == cactusSmall) {
      return Sprite(
        spriteImage,
        srcPosition: Vector2(446.0, 2.0),
        srcSize: Vector2(spriteWidth, spriteHeight),
      );
    }
    return Sprite(
      spriteImage,
      srcPosition: Vector2(652.0, 2.0),
      srcSize: Vector2(spriteWidth, spriteHeight),
    );
  }

  @override
  String toString() {
    return type;
  }
}
