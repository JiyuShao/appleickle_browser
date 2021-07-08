import 'package:flutter/material.dart';
import 'package:appleickle_browser/utils/routes/page_routes/common_page_route_builder.dart';

Widget _transitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

class FadePageRoute<T> extends CommonPageRouteBuilder<T> {
  FadePageRoute({
    RouteSettings? settings,
    required this.pageBuilder,
  }) : super(
          settings: settings,
          barrierLabel: 'FadePageRoute',
          pageBuilder: pageBuilder,
          maintainState: false,
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: _transitionsBuilder,
        );

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
