import 'dart:async';

/// Delays invoking [run]'s callback until [duration] has passed without a
/// new call — used by `SearchField` so every keystroke doesn't trigger a
/// fresh API call.
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 400)});

  final Duration duration;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
