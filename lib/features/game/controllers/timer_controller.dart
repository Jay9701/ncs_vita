import 'dart:async';

class TimerController {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  Duration _total; // 전체 시간
  final Duration tickInterval; // 화면 업데이트 주기

  void Function(Duration remaining)? onTick;
  void Function()? onFinish;

  TimerController({
    required Duration totalTime,
    this.tickInterval = const Duration(milliseconds: 100),
    this.onTick,
    this.onFinish,
  }) : _total = totalTime;

  // 경과 시간
  Duration get elapsed => _stopwatch.elapsed;

  // 남은 시간
  Duration get remaining {
    final diff = _total - elapsed;
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get isRunning => _stopwatch.isRunning;

  // 시작 또는 재개
  void start() {
    if (isRunning) return;

    _stopwatch.start();

    _ticker ??= Timer.periodic(tickInterval, (_) {
      onTick?.call(remaining);

      if (remaining == Duration.zero) {
        stop();
        onFinish?.call();
      }
    });
  }

  // 일시정지
  void pause() {
    if (!isRunning) return;
    _stopwatch.stop();
  }

  // 완전 정지
  void stop() {
    _stopwatch.stop();
    _ticker?.cancel();
    _ticker = null;
  }

  // 초기화 + 새 시간 설정
  void reset(Duration newTotal) {
    stop();
    _stopwatch.reset();
    _total = newTotal;
    onTick?.call(remaining);
  }

  // 시간 증감 (+/-)
  void addTime(Duration delta) {
    final newTotal = _total + delta;

    // 총 시간이 경과 시간보다 작아지지 않도록 보정
    _total = newTotal <= elapsed ? elapsed : newTotal;

    onTick?.call(remaining);
  }

  // 해제
  void dispose() {
    stop();
  }
}
