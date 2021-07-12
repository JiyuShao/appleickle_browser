import 'package:flutter/material.dart';

class SearchHero extends Hero {
  // Hero 动画相关 tag
  final String heroTag;
  // 搜索按钮动画
  static const String SEARCH_SCREEN_HERO_TAG = 'SEARCH_SCREEN_HERO_TAG';

  // 自定义的子元素
  final Widget child;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;

  SearchHero(
      {required this.child, required this.heroTag, this.flightShuttleBuilder})
      : super(
          tag: '${SearchHero.SEARCH_SCREEN_HERO_TAG}/$heroTag',
          flightShuttleBuilder: flightShuttleBuilder,
          child: child,
        );
}
