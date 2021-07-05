import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';

// 默认动画生成器
Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return child;
}

class CommonPageRouteBuilder<T> extends PageRoute<T> {
  CommonPageRouteBuilder({
    RouteSettings? settings,
    required this.barrierLabel,
    // 页面生成器
    required this.pageBuilder,
    // 动画生成器
    this.transitionsBuilder = _defaultTransitionsBuilder,
    // 动画时间
    this.transitionDuration =
        const Duration(milliseconds: AppTheme.baseAnimationDuration),
    // 反向动画时间
    this.reverseTransitionDuration =
        const Duration(milliseconds: AppTheme.baseAnimationDuration),
    // 是否保留状态
    this.maintainState = false,
    // 是否隐藏背景路由, 隐藏的话没有 Hero 返回动画
    this.opaque = false,
    // 点击背景是否可以关闭
    this.barrierDismissible = false,
    // 背景颜色
    this.barrierColor = AppTheme.dialogBackgroundColor,
  }) : super(settings: settings);

  // 页面生成器
  final RoutePageBuilder pageBuilder;

  // 动画生成器
  final RouteTransitionsBuilder transitionsBuilder;

  // 是否保留状态
  @override
  final bool maintainState;

  // 是否隐藏背景路由
  @override
  final bool opaque;

  // 背景名称
  @override
  final String barrierLabel;

  // 背景颜色
  @override
  final Color barrierColor;

  // 点击背景是否可以关闭
  @override
  final bool barrierDismissible;

  // 动画耗时
  @override
  final Duration transitionDuration;

  // reverse动画耗时
  @override
  final Duration reverseTransitionDuration;

  // 生成页面
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  // 生成动画
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return transitionsBuilder(context, animation, secondaryAnimation, child);
  }
}
