import 'dart:math';
import 'package:flame/components.dart';

import '../collision/collision_box.dart';

var jumpHeight = 300;
var jumpTime = 0.65;

class TRexConfig {
  // 跳的高度
  final jumpHeight = 300;
  // 跳的时间
  final double jumpTime = 0.65;
  // 重力加速度
  // 计算方法: gravity = jumpHeight / pow(jumpTime / 2, 2)
  final double gravity = 300 / pow(0.65 / 2, 2);
  // 初始起跳速度
  // 计算方法: (jumpHeight / pow(jumpTime / 2, 2) * jumpTime / 2)
  final double jumpVelocity = -(300 / pow(0.65 / 2, 2) * 0.65 / 2);

  // 加速度
  final double acceleration = 6;
  // 基础速度, 当前速度/基础速度会影响障碍物生成系数
  final double minSpeed = 230;
  // 最大速度
  final double maxSpeed = 350.0;
  // 起始点位置
  final double startXPos = 50.0;
  // 从头跑到起始点的时间
  final double startDuration = 0.3;
  // 实际展示的大小
  final double width = 45.0;
  final double height = 45.0;
}

final tRexCollisionBoxesDucking = <CollisionBox>[
  CollisionBox(
    position: Vector2(1.0, 18.0),
    size: Vector2(110.0, 50.0),
  ),
];

final tRexCollisionBoxesRunning = <CollisionBox>[
  CollisionBox(
    position: Vector2(22.0, 0.0),
    size: Vector2(34.0, 32.0),
  ),
  CollisionBox(
    position: Vector2(1.0, 18.0),
    size: Vector2(60.0, 18.0),
  ),
  CollisionBox(
    position: Vector2(10.0, 35.0),
    size: Vector2(28.0, 16.0),
  ),
  CollisionBox(
    position: Vector2(1.0, 24.0),
    size: Vector2(58.0, 10.0),
  ),
  CollisionBox(
    position: Vector2(5.0, 30.0),
    size: Vector2(42.0, 8.0),
  ),
  CollisionBox(
    position: Vector2(9.0, 34.0),
    size: Vector2(30.0, 8.0),
  )
];
