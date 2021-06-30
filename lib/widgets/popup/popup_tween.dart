import 'dart:ui' show lerpDouble;
import 'package:flutter/widgets.dart';

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
