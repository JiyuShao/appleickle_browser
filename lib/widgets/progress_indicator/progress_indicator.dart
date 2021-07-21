import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  // 当前的值
  final double value;
  // 高度
  final double height;
  // 动画时长
  final Duration duration;
  // 动画结束回调, 如果返回的是 true 的话就隐藏当前组件
  final bool Function(double value)? handleAnimationFinish;

  const ProgressBar({
    Key? key,
    required this.value,
    this.height = 4,
    this.duration = const Duration(milliseconds: 100),
    this.handleAnimationFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var width = value * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: height,
              decoration: BoxDecoration(
                color: Color(0xffd3d3d3),
                borderRadius: BorderRadius.circular(height),
              ),
            ),
            AnimatedContainer(
              duration: duration,
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(height),
              ),
              onEnd: () {
                if (handleAnimationFinish != null) {
                  handleAnimationFinish!(value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
