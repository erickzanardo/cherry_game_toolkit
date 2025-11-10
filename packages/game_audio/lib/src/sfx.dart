import 'dart:async';

import 'package:game_audio/game_audio.dart';

class SfxService {
  SfxService({required AudioController audioController})
    : _audioController = audioController;

  final AudioController _audioController;

  final Map<String, Timer> _timers = {};

  bool isSoundEnabled = false;

  double volume = 1;

  Future<void> precache() async {
    // Noop
  }

  void sfx(String file, {double? volume}) {
    if (isSoundEnabled) {
      _audioController.playSound(file, volume: volume ?? this.volume);
    }
  }

  void start(String file, {Duration interval = const Duration(seconds: 1)}) {
    if (!isSoundEnabled || _timers.containsKey(file)) {
      return;
    }

    _audioController.playSound(file);
    final timer = Timer.periodic(interval, (_) {
      if (isSoundEnabled) {
        _audioController.playSound(file, volume: volume);
      }
    });

    _timers[file] = timer;
  }

  void stop(String file) {
    final timer = _timers[file];
    if (timer != null) {
      timer.cancel();
      _timers.remove(file);
    }
  }
}
