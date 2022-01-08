/*
 * icon 按钮, 主要用于底部导航栏和设置页
 * @Author: Jiyu Shao 
 * @Date: 2021-06-29 19:18:14 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-12-11 17:44:13
 */
import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/icon_button_item_model.dart';

class IconButtonItem extends StatefulWidget {
  const IconButtonItem({
    Key? key,
    required this.model,
    required this.handleTap,
  }) : super(key: key);

  // 当前Tab数据
  final IconButtonItemModel model;
  // 触发点击逻辑
  final Function() handleTap;

  @override
  _IconButtonItemState createState() => _IconButtonItemState();
}

class _IconButtonItemState extends State<IconButtonItem>
    with TickerProviderStateMixin {
  // 动画控制器
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addStatusListener((AnimationStatus status) {
        if (!mounted) return;
        if (animationController.isCompleted) {
          // 在切换动画执行结束后, 撤销动画
          animationController.reverse();
        } else if (animationController.isDismissed) {
          // 撤销动画之后触发回调
          widget.handleTap();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // 处理 Tab 点击逻辑
  void handleTap() {
    // 执行切换动画, 动画结束后触发点击回调
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleTap();
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ScaleTransition(
              alignment: Alignment.center,
              scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
              child: Image.asset(
                widget.model.imagePath,
                width: 38,
                height: 38,
              ),
            ),
            Positioned(
              top: 4,
              left: 6,
              right: 0,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve:
                            Interval(0.2, 1.0, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 6,
              bottom: 8,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve:
                            Interval(0.5, 0.8, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 8,
              bottom: 0,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve:
                            Interval(0.5, 0.6, curve: Curves.fastOutSlowIn))),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
