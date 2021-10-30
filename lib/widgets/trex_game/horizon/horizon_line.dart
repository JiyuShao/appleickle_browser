import 'dart:ui';

import 'package:flame/components.dart';

import '../obstacle/obstacle.dart';
import '../game.dart';
import 'clouds.dart';
import 'config.dart';

class HorizonLine extends PositionComponent with HasGameRef<TRexGame> {
  final config = HorizonConfig();

  // grounds
  late final firstGround = SpriteComponent(
    size: Vector2(config.width, config.height),
    sprite: Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(2.0, 104.0),
      srcSize: Vector2(1200.0, 24.0),
    ),
  );
  late final secondGround = SpriteComponent(
    size: Vector2(config.width, config.height),
    sprite: Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(2.0 + 1200.0, 104.0),
      srcSize: Vector2(1200.0, 24.0),
    ),
  );
  late final thirdGround = SpriteComponent(
    size: Vector2(config.width, config.height),
    sprite: Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(2.0, 104.0),
      srcSize: Vector2(1200.0, 24.0),
    ),
  );

  // children
  late final CloudManager cloudManager = CloudManager(horizonConfig: config);
  late final ObstacleManager obstacleManager =
      ObstacleManager(horizonConfig: config);

  @override
  void onMount() {
    addChild(firstGround);
    addChild(secondGround);
    addChild(thirdGround);
    addChild(cloudManager);
    addChild(obstacleManager);
    super.onMount();
  }

  void updateXPos(int indexFirst, double increment) {
    final grounds = [firstGround, secondGround, thirdGround];

    final first = grounds[indexFirst];
    final second = grounds[(indexFirst + 1) % 3];
    final third = grounds[(indexFirst + 2) % 3];

    first.x -= increment;
    second.x = first.x + config.width;
    third.x = second.x + config.width;

    if (first.x <= -config.width) {
      first.x += config.width * 3;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = gameRef.currentSpeed * dt;
    final index = firstGround.x <= 0
        ? 0
        : secondGround.x <= 0
            ? 1
            : 2;
    updateXPos(index, increment);
  }

  void reset() {
    cloudManager.reset();
    obstacleManager.reset();

    firstGround.x = 0.0;
    secondGround.x = config.width;
  }
}

class HorizonGround extends SpriteComponent {
  HorizonGround({
    // 精灵图
    required Image spriteImage,
    // 精灵图位置
    required Vector2 srcPosition,
    // TRex 配置
    required HorizonConfig config,
  }) : super(
          size: Vector2(config.width, config.height),
          sprite: Sprite(
            spriteImage,
            srcPosition: srcPosition,
            srcSize: Vector2(1200.0, 24.0),
          ),
        );
}
