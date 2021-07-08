import 'package:flutter/material.dart';
import 'package:appleickle_browser/utils/routes/page_routes/common_page_route_builder.dart';

class PopupPageRoute<T> extends CommonPageRouteBuilder<T> {
  PopupPageRoute({
    RouteSettings? settings,
    required this.pageBuilder,
  }) : super(
          settings: settings,
          barrierLabel: 'PopupPageRoute',
          pageBuilder: pageBuilder,
          maintainState: false,
          opaque: false,
          barrierDismissible: true,
        );

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
