import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:appleickle_browser/utils/routes/page_routes/common_page_route_builder.dart';

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
          transitionDuration: Duration(
            milliseconds: AppThemeModel.baseAnimationDuration ~/ 2,
          ),
        );

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
