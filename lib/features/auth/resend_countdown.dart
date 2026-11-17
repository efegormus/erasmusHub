import 'dart:async';

import 'package:flutter/foundation.dart';

/// Counts down from [duration] once per second, for "send again" buttons.
/// The owning State must call [dispose].
class ResendCountdown extends ValueNotifier<int> {
  ResendCountdown(this.duration) : super(0);

  final Duration duration;
  Timer? _timer;

  bool get isRunning => value > 0;

  /// "02:59" style label of the remaining time.
  String get label =>
      '${(value ~/ 60).toString().padLeft(2, '0')}:'
      '${(value % 60).toString().padLeft(2, '0')}';

  void start() {
    _timer?.cancel();
    value = duration.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value <= 1) {
        timer.cancel();
        value = 0;
      } else {
        value--;
      }
    });
  }

  /// Ends the countdown early so "send again" becomes available.
  void stop() {
    _timer?.cancel();
    value = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
