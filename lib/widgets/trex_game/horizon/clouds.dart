import 'dart:ui';

import 'package:flame/components.dart';
import '../custom/util.dart';
import '../game.dart';
import './config.dart';

class Cloud extends SpriteComponent with HasGameRef<TRexGame> {
  Cloud({
    required this.config,
    required Image spriteImage,
  })  : cloudGap = getRandomNum(
          config.minCloudGap,
          config.maxCloudGap,
        ),
        super(
          size: Vector2(config.width, config.height),
          sprite: Sprite(
            spriteImage,
            srcPosition: Vector2(166.0, 2.0),
            srcSize: Vector2(92.0, 28.0),
          ),
        );

  final CloudConfig config;
  final double cloudGap;
  bool get allowNextCloud => (gameRef.size.x / 2 - x) > cloudGap;

  @override
  void update(double dt) {
    super.update(dt);
    if (shouldRemove) {
      return;
    }
    x -= (parent as CloudManager).cloudSpeed.ceil() * dt;

    if (!isVisible) {
      remove();
    }
  }

  bool get isVisible {
    return x + config.width > 0;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    y = ((absolutePosition.y / 2 - (config.maxSkyLevel - config.minSkyLevel)) +
            getRandomNum(config.minSkyLevel, config.maxSkyLevel)) -
        absoluteParentPosition.y;
  }
}

class CloudManager extends PositionComponent with HasGameRef<TRexGame> {
  CloudManager({
    required this.horizonConfig,
  });

  final HorizonConfig horizonConfig;
  late final CloudConfig cloudConfig = CloudConfig();

  void addCloud() {
    final cloud = Cloud(
      config: cloudConfig,
      spriteImage: gameRef.spriteImage,
    );
    cloud.x = gameRef.size.x + cloudConfig.width + 10;
    cloud.y = ((absolutePosition.y / 2 -
                (cloudConfig.maxSkyLevel - cloudConfig.minSkyLevel)) +
            getRandomNum(cloudConfig.minSkyLevel, cloudConfig.maxSkyLevel)) -
        absolutePosition.y;
    addChild(cloud);
  }

  double get cloudSpeed => horizonConfig.bgCloudSpeed * gameRef.currentSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    final int numClouds = children.length;
    if (numClouds > 0) {
      final lastCloud = children.last as Cloud;
      if (numClouds < horizonConfig.maxClouds && lastCloud.allowNextCloud) {
        addCloud();
      }
    } else {
      addCloud();
    }
  }

  void reset() {
    clearChildren();
  }
}
