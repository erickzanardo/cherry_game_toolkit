import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_audio/game_audio.dart';

class Jukebox extends WidgetsBindingObserver {
  Jukebox({required this.musics, required AudioController audioController})
    : _audioController = audioController;

  final AudioController _audioController;

  final List<String> musics;

  var _index = 0;
  bool _startedPlaying = false;
  double _volume = 1;
  bool isMusicEnabled = true;
  String? _looping;

  String? get looping => _looping;

  double get volume => _volume;

  set volume(double value) {
    _volume = value;
    _audioController.updateMusicVolume(value);
  }

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
  }

  void loop(String music) {
    if (music != _looping) {
      _looping = music;
      _audioController.startMusic(music).then((_) {
        _looping = null;
        loop(music);
      });
    }
  }

  void startPlaying() {
    if (musics.isEmpty) {
      return;
    }
    _looping = null;

    _audioController.startMusic(musics[_index]).then((_) {
      if (_looping == null) {
        _playNextMusic();
      }
    });

    _startedPlaying = true;
  }

  void pause() {
    _audioController.pauseMusic();
  }

  void resume() {
    if (_startedPlaying) {
      _audioController.resumeMusic();
    } else {
      startPlaying();
    }
  }

  void stop() {
    _audioController.stopMusic();
  }

  void _playNextMusic() {
    _looping = null;
    _index = (_index + 1) % musics.length;
    _audioController.startMusic(musics[_index]).then((_) {
      _playNextMusic();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_startedPlaying) {
      if (state == AppLifecycleState.resumed) {
        if (isMusicEnabled) {
          _audioController.resumeMusic();
        }
      } else {
        _audioController.pauseMusic();
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioController.stopMusic();
  }
}
