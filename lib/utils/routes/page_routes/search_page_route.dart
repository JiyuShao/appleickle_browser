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
        );

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
