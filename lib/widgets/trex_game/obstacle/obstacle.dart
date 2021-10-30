import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';

import '../collision/collision_box.dart';
import '../custom/util.dart';
import '../horizon/config.dart';
import '../game.dart';
import './config.dart';
import './obstacle_type.dart';

class ObstacleManager extends PositionComponent with HasGameRef<TRexGame> {
  ObstacleManager(this.hrizonConfig);

  ListQueue<ObstacleType> history = ListQueue();
  final ObstacleConfig config = ObstacleConfig();
  final HorizonConfig hrizonConfig;

  @override
  void update(double dt) {
    for (final c in children) {
      final obstacle = c as Obstacle;
      obstacle.y = y - obstacle.type.height * 0.75;
    }

    if (children.isNotEmpty) {
      final lastObstacle = children.last as Obstacle?;
      // 如果存在障碍物, 并且最后一个障碍物目前允许添加新的障碍物
      if (lastObstacle != null && lastObstacle.allowNextObstacle) {
        addNewObstacle();
      }
    } else {
      addNewObstacle();
    }

    super.update(dt);
  }

  void addNewObstacle() {
    final type = getRandomNum(0.0, 1.0).round() == 0
        ? ObstacleType.cactusSmall
        : ObstacleType.cactusLarge;
    if (duplicateObstacleCheck(type)) {
      return;
    } else {
      final obstacle = Obstacle(
        type: type,
        spriteImage: gameRef.spriteImage,
        hrizonConfig: hrizonConfig,
      );

      obstacle.x = gameRef.size.x;

      addChild(obstacle);

      history.addFirst(type);
      if (history.length > 1) {
        final sublist =
            history.toList().sublist(0, config.maxObstacleDuplication);
        history = ListQueue.from(sublist);
      }
    }
  }

  bool duplicateObstacleCheck(ObstacleType nextType) {
    int duplicateCount = 0;

    for (final c in history) {
      duplicateCount += c.type == nextType.type ? 1 : 0;
    }
    return duplicateCount >= config.maxObstacleDuplication;
  }

  void reset() {
    clearChildren();
    history.clear();
  }
}

// 障碍物
class Obstacle extends SpriteComponent with HasGameRef<TRexGame> {
  Obstacle({
    required this.type,
    required Image spriteImage,
    required HorizonConfig hrizonConfig,
  }) : super(
          sprite: type.getSprite(spriteImage),
        ) {
    // 设置障碍物位置
    x = hrizonConfig.width;

    // 根据障碍物数量, 设置障碍物宽度
    width = type.width * internalSize;
    height = type.height;

    // 设置在屏幕上有障碍物的情况下, 与下一个障碍物的间隔, 这里传入当前速度和初始速度比
    gap = computeGap();

    // 设置雪碧图的位置和大小
    final actualSrc = sprite!.src;
    sprite!.src = Rect.fromLTWH(
      actualSrc.left,
      actualSrc.top,
      actualSrc.width * internalSize,
      actualSrc.height,
    );
  }

  final ObstacleConfig config = ObstacleConfig();

  late double gap;

  late int internalSize = getRandomNum(
    1.0,
    config.maxObstacleLength / 1,
  ).floor();

  ObstacleType type;

  late List<CollisionBox> collisionBoxes = [
    for (final box in type.collisionBoxes) CollisionBox.from(box)
  ];

  // 当前是否可以添加新障碍物
  bool get allowNextObstacle {
    return (x + width + gap) < gameRef.size.x;
  }

  // 当前障碍物是否可以被销毁
  bool get isVisible => (x + width) > 0;

  double computeGap() {
    final minGap = (type.minGap).round() / 1;
    final maxGap = (minGap * config.gapCoefficient).round() / 1;
    return getRandomNum(minGap, maxGap);
  }

  @override
  void update(double dt) {
    if (shouldRemove) {
      return;
    }

    final increment = gameRef.currentSpeed * dt;
    x -= increment;

    if (!isVisible) {
      remove();
    }
    super.update(dt);
  }
}
