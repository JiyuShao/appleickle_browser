import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';

class PopupPageRoute<T> extends PageRoute<T> {
  PopupPageRoute({
    RouteSettings? settings,
    required this.builder,
  }) : super(settings: settings);

  // 渲染器
  final WidgetBuilder builder;

  // 是否保留状态
  @override
  bool get maintainState => false;

  // 是否隐藏背景路由
  @override
  bool get opaque => false;

  // 背景名称
  @override
  String get barrierLabel => 'PopupPageRoute';

  // 背景颜色
  @override
  Color get barrierColor => AppTheme.dialogBackgroundColor;

  // 点击背景是否可以关闭
  @override
  bool get barrierDismissible => true;

  // 动画耗时
  @override
  Duration get transitionDuration =>
      const Duration(milliseconds: AppTheme.baseAnimationDuration);

  // 动画样式样式
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  // 构建页面
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return this.builder(context);
  }
}
