import 'dart:async';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');

  SoLoud? _soloud;

  SoundHandle? _musicHandle;
  StreamSubscription<StreamSoundEvent>? _musicSubscription;

  Future<void> initialize() async {
    _soloud = SoLoud.instance;
    await _soloud!.init();
  }

  void dispose() {
    _soloud?.deinit();
  }

  Future<void> playSound(String assetKey, {double volume = 1}) async {
    try {
      final source = await _soloud!.loadAsset(assetKey);
      await _soloud!.play(source, volume: volume);
    } on SoLoudException catch (e) {
      _log.severe("Cannot play sound '$assetKey'. Ignoring.", e);
    }
  }

  Future<void> pauseMusic() async {
    if (_musicHandle != null && _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      _soloud!.setPause(_musicHandle!, true);
      _log.info('Music paused.');
    } else {
      _log.warning('No valid music handle to pause.');
    }
  }

  Future<void> resumeMusic() async {
    if (_musicHandle != null && _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      _soloud!.setPause(_musicHandle!, false);
      _log.info('Music resumed.');
    } else {
      _log.warning('No valid music handle to resume.');
    }
  }

  Future<void> startMusic(String source, {double volume = 1}) async {
    final completer = Completer<void>();
    if (_musicHandle != null) {
      if (_soloud!.getIsValidVoiceHandle(_musicHandle!)) {
        _log.info('Music is already playing. Stopping first.');
        await _soloud!.stop(_musicHandle!);
        await _musicSubscription?.cancel();
      }
    }
    final musicSource = await _soloud!.loadAsset(source, mode: LoadMode.disk);

    _musicHandle = await _soloud!.play(musicSource, volume: volume);

    _musicSubscription = musicSource.soundEvents.listen((event) async {
      if (event.event == SoundEventType.soundDisposed ||
          event.event == SoundEventType.handleIsNoMoreValid) {
        await _musicSubscription?.cancel();
        _log.info('Music playback completed.');
        completer.complete();
      }
    });

    return completer.future;
  }

  Future<void> stopMusic() async {
    if (_musicHandle != null && _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      await _soloud!.stop(_musicHandle!);
      await _musicSubscription?.cancel();
      _musicHandle = null;
      _musicSubscription = null;
      _log.info('Music stopped.');
    } else {
      _log.warning('No valid music handle to stop.');
    }
  }

  Future<void> updateMusicVolume(double volume) async {
    if (_musicHandle != null && _soloud!.getIsValidVoiceHandle(_musicHandle!)) {
      _soloud!.setVolume(_musicHandle!, volume);
      _log.info('Music volume updated to $volume.');
    } else {
      _log.warning('No valid music handle to update volume.');
    }
  }
}
