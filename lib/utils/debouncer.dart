import 'dart:async';

class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({required this.milliseconds});

  void run({required void Function() callback}) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
