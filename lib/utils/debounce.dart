/*
 * 防抖
 * @Author: Jiyu Shao 
 * @Date: 2021-07-06 18:30:10 
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2021-07-06 19:51:24
 * @Reference https://pub.dev/packages/easy_debounce
 */
import 'dart:async';

/// A void callback, i.e. (){}, so we don't need to import e.g. `dart.ui`
/// just for the VoidCallback type definition.
typedef DebounceCallback = dynamic Function();

/// A static class for handling method call debouncing.
class Debounce {
  static Map<Symbol, Timer> _timers = {};

  /// Will delay the execution of [onExecute] with the given [duration]. If another call to
  /// debounce() with the same [tag] happens within this duration, the first call will be
  /// cancelled and the debouncer will start waiting for another [duration] before executing
  /// [onExecute].
  ///
  /// [tag] is any arbitrary Symbol, and is used to identify this particular debounce
  /// operation in subsequent calls to [debounce()] or [cancel()].
  ///
  /// If [duration] is `Duration.zero`, [onExecute] will be executed immediately, i.e.
  /// synchronously.
  static void debounce(
      Symbol tag, Duration duration, DebounceCallback onExecute) {
    if (duration == Duration.zero) {
      _timers[tag]?.cancel();
      _timers.remove(tag);
      onExecute();
    } else {
      _timers[tag]?.cancel();

      _timers[tag] = Timer(duration, () {
        _timers[tag]?.cancel();
        _timers.remove(tag);
        onExecute();
      });
    }
  }

  /// Cancels any active debounce operation with the given [tag].
  static void cancel(Symbol tag) {
    _timers[tag]?.cancel();
    _timers.remove(tag);
  }

  /// Returns the number of active debouncers (debouncers that haven't yet called their
  /// [onExecute] methods).
  static int count() {
    return _timers.length;
  }
}
