import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../game.dart';
import '../t_rex/config.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting, intro }

class TRex extends PositionComponent with HasGameRef<TRexGame> {
  final config = TRexConfig();

  // state
  TRexStatus status = TRexStatus.waiting;
  bool isIdle = true;

  double jumpVelocity = 0;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  // ref to children
  late final TRexStateStillComponent waitingTRex = TRexStateStillComponent(
    config: config,
    showFor: [TRexStatus.waiting],
    spriteImage: gameRef.spriteImage,
    srcPosition: Vector2(1339.0, 2.0),
    srcSize: Vector2(86.0, 94.0),
  );
  late final TRexStateAnimatedComponent runningTRex =
      TRexStateAnimatedComponent(
    config: config,
    showFor: [TRexStatus.running, TRexStatus.intro],
    spriteImage: gameRef.spriteImage,
    frames: [Vector2(1515.0, 2.0), Vector2(1603.0, 2.0)],
    srcSize: Vector2(86.0, 94.0),
  );
  late final TRexStateStillComponent jumpingTRex = TRexStateStillComponent(
    config: config,
    showFor: [TRexStatus.jumping],
    spriteImage: gameRef.spriteImage,
    srcPosition: Vector2(1339.0, 2.0),
    srcSize: Vector2(86.0, 94.0),
  );
  late final TRexStateStillComponent surprisedTRex = TRexStateStillComponent(
    config: config,
    showFor: [TRexStatus.crashed],
    spriteImage: gameRef.spriteImage,
    srcPosition: Vector2(1782.0, 2.0),
    srcSize: Vector2(83.0, 94.0),
  );

  bool get playingIntro => status == TRexStatus.intro;

  bool get ducking => status == TRexStatus.ducking;

  double get groundYPos {
    return (gameRef.size.y / 2) - config.height / 2;
  }

  @override
  Future? onLoad() {
    addChild(waitingTRex);
    addChild(runningTRex);
    addChild(jumpingTRex);
    addChild(surprisedTRex);
  }

  void startJump(double speed) {
    if (status == TRexStatus.jumping || status == TRexStatus.ducking) {
      return;
    }

    status = TRexStatus.jumping;
    jumpVelocity = config.jumpVelocity;
  }

  void reset() {
    y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = TRexStatus.running;
  }

  @override
  void update(double dt) {
    if (status == TRexStatus.jumping) {
      y += jumpVelocity;
      jumpVelocity += gameRef.config.gravity;
      if (y > groundYPos) {
        reset();
        jumpCount++;
      }
    } else {
      y = groundYPos;
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) {
      status = TRexStatus.intro;
    }
    if (playingIntro && x < config.startXPos) {
      x += (config.startXPos * dt) / config.startDuration;
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    y = groundYPos;
    super.onGameResize(gameSize);
  }
}

mixin TRexStateVisibility on BaseComponent {
  late final List<TRexStatus> showFor;

  @override
  TRex get parent => super.parent as TRex;

  @override
  void render(Canvas canvas) {
    final show = showFor.any((element) => element == parent.status);
    if (!show) {
      return;
    }
    super.render(canvas);
  }
}

/// A component superclass for TRex states with still sprites
class TRexStateStillComponent extends SpriteComponent with TRexStateVisibility {
  TRexStateStillComponent({
    // 需要展示的状态列表
    required List<TRexStatus> showFor,
    // 精灵图
    required Image spriteImage,
    // 精灵图位置
    required Vector2 srcPosition,
    // 精灵图大小
    required Vector2 srcSize,
    // TRex 配置
    required TRexConfig config,
  }) : super(
          size: Vector2(config.width, config.height),
          sprite: Sprite(
            spriteImage,
            srcPosition: srcPosition,
            srcSize: srcSize,
          ),
        ) {
    this.showFor = showFor;
  }
}

class TRexStateAnimatedComponent extends SpriteAnimationComponent
    with TRexStateVisibility {
  TRexStateAnimatedComponent({
    // 需要展示的状态列表
    required List<TRexStatus> showFor,
    // 精灵图
    required Image spriteImage,
    // 精灵图位置列表
    required List<Vector2> frames,
    // 精灵图大小
    required Vector2 srcSize,
    // TRex 配置
    required TRexConfig config,
  }) : super(
          size: Vector2(config.width, config.height),
          animation: SpriteAnimation.spriteList(
            frames
                .map((vector) => Sprite(
                      spriteImage,
                      srcSize: srcSize,
                      srcPosition: vector,
                    ))
                .toList(),
            stepTime: 0.06,
            loop: true,
          ),
        ) {
    this.showFor = showFor;
  }
}
