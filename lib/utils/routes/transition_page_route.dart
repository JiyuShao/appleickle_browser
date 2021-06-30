import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pickle_browser/models/app_theme.dart';

class TransitionPageRoute<T> extends PageRoute<T> {
  TransitionPageRoute({
    required WidgetBuilder builder,
  })  : _builder = builder,
        super();

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration =>
      const Duration(milliseconds: AppTheme.baseAnimationDuration);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => AppTheme.background;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'TransitionPageRoute';
}
