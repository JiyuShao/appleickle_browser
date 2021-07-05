import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';
import 'package:pickle_browser/utils/routes/page_routes/common_page_route_builder.dart';

class SearchPageRoute<T> extends CommonPageRouteBuilder<T> {
  SearchPageRoute({
    RouteSettings? settings,
    required this.pageBuilder,
  }) : super(
            settings: settings,
            barrierLabel: 'SearchPageRoute',
            pageBuilder: pageBuilder,
            maintainState: true,
            opaque: false,
            barrierDismissible: true,
            transitionDuration: const Duration(
              milliseconds: AppTheme.baseAnimationDuration * 5,
            ),
            reverseTransitionDuration: const Duration(
                milliseconds: AppTheme.baseAnimationDuration * 5));

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
