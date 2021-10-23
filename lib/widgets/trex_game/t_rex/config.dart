import 'package:flame/components.dart';

import '../collision/collision_box.dart';

class TRexConfig {
  // 重力加速度
  final double gravity = 1.2;
  // 起始点位置
  final double startXPos = 50.0;
  // 从头跑到起始点的时间(s)
  final double startDuration = 0.8;
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
