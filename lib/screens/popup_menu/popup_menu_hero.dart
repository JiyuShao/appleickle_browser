import 'dart:ui';

import 'package:flutter/material.dart';

class PopupMenuHero extends Hero {
  // Hero 动画相关 tag
  final String heroTag;
  PopupMenuHero({required this.child, required this.heroTag})
      : super(
          tag: '${PopupMenuHero.POPUP_MENU_SCREEN_HERO_TAG}/$heroTag',
          createRectTween: (begin, end) {
            return PopupRectTween(begin: begin, end: end);
          },
          child: child,
        );

  // 弹窗菜单Hero动画tag
  static const String POPUP_MENU_SCREEN_HERO_TAG = 'POPUP_MENU_SCREEN_HERO_TAG';

  // 自定义的子元素
  final Widget child;
}

class PopupRectTween extends Tween<Rect?> {
  /// Creates a [Rect] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as an empty rect at the top left corner.
  PopupRectTween({Rect? begin, Rect? end}) : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  Rect? lerp(double t) {
    final begin = this.begin;
    final end = this.end;
    if (begin == null || end == null) {
      return null;
    }
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue)!,
      lerpDouble(begin.top, end.top, elasticCurveValue)!,
      lerpDouble(begin.right, end.right, elasticCurveValue)!,
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue)!,
    );
  }
}
