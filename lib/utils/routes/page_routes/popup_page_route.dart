import 'package:flutter/material.dart';
import 'package:appleickle_browser/models/app_theme_model.dart';
import 'package:appleickle_browser/utils/routes/page_routes/common_page_route_builder.dart';

Widget _transitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

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
          transitionsBuilder: _transitionsBuilder,
          transitionDuration: Duration(
            milliseconds: AppThemeModel.baseAnimationDuration,
          ),
          reverseTransitionDuration: Duration(
            milliseconds: AppThemeModel.baseAnimationDuration * 2,
          ),
        );

  // 页面生成器
  final RoutePageBuilder pageBuilder;
}
