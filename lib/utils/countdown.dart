import 'dart:async';

import 'package:flutter/foundation.dart';

/// Mirrors web `src/utils/useCountdown.util.ts`.
class CountdownController extends ChangeNotifier {
  CountdownController([this.defaultSeconds = 0]);

  final int defaultSeconds;

  int _targetTimeMs = 0;
  Timer? _timer;

  int get targetTimeMs => _targetTimeMs;

  int get secondsLeft {
    final diff = _targetTimeMs - DateTime.now().millisecondsSinceEpoch;
    return diff <= 0 ? 0 : (diff / 1000).ceil();
  }

  bool get isActive => secondsLeft > 0;

  void start([int? seconds]) {
    final normalizedSeconds = (seconds ?? defaultSeconds).ceil();
    if (normalizedSeconds <= 0) {
      clear();
      return;
    }
    _targetTimeMs =
        DateTime.now().millisecondsSinceEpoch + normalizedSeconds * 1000;
    _startTicker();
    notifyListeners();
  }

  void startAt(int nextTargetTimeMs) {
    _targetTimeMs = nextTargetTimeMs > 0 ? nextTargetTimeMs : 0;
    if (isActive) {
      _startTicker();
    } else {
      _stopTicker();
    }
    notifyListeners();
  }

  void clear() {
    _targetTimeMs = 0;
    _stopTicker();
    notifyListeners();
  }

  void _startTicker() {
    _stopTicker();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isActive) {
        _targetTimeMs = 0;
        _stopTicker();
      }
      notifyListeners();
    });
  }

  void _stopTicker() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
