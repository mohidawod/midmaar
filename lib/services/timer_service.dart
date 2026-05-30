import 'dart:async';

class TimerService {
  Timer? _timer;
  int _remaining = 10;
  Function(int)? _onTick;
  Function()? _onEnd;

  void start({Function(int)? onTick, Function()? onEnd}) {
    stop();
    _remaining = 10;
    _onTick = onTick;
    _onEnd = onEnd;
    onTick?.call(_remaining);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _remaining--;
      _onTick?.call(_remaining);
      if (_remaining <= 0) {
        stop();
        _onEnd?.call();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  int get remaining => _remaining;
}
