import 'package:flutter/material.dart';

class SearchHero extends Hero {
  SearchHero({required this.child})
      : super(
          tag: SearchHero.SEARCH_SCREEN_HERO_TAG,
          child: child,
        );

  // 搜索按钮动画
  static const String SEARCH_SCREEN_HERO_TAG = 'SEARCH_SCREEN_HERO_TAG';

  // 自定义的子元素
  final Widget child;
}
