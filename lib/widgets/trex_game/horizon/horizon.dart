import 'package:flame/components.dart';

import '../game.dart';
import 'horizon_line.dart';

class Horizon extends PositionComponent with HasGameRef<TRexGame> {
  Horizon({
    required this.deltaY,
  });
  // y 方向定位偏移量
  final double deltaY;

  late final horizonLine = HorizonLine();

  @override
  Future<void>? onLoad() {
    addChild(horizonLine);
  }

  @override
  void update(double dt) {
    // 这里要与小恐龙的初始状态对齐
    y = (gameRef.size.y / 2) + deltaY;
    super.update(dt);
  }

  void reset() {
    horizonLine.reset();
  }
}
