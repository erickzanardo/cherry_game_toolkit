import 'package:flutter/material.dart';

import 'package:game_audio/game_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jukebox Test',
      home: Scaffold(body: const Center(child: JukeboxTestWidget())),
    );
  }
}

class JukeboxTestWidget extends StatefulWidget {
  const JukeboxTestWidget({super.key});

  @override
  State<JukeboxTestWidget> createState() => _JukeboxTestWidgetState();
}

class _JukeboxTestWidgetState extends State<JukeboxTestWidget> {
  late final Jukebox _jukebox;
  late final AudioController _audioController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    _audioController = AudioController();

    await _audioController.initialize();
    _jukebox = Jukebox(
      musics: ['assets/music_1.mp3', 'assets/music_2.mp3'],
      audioController: _audioController,
    );
    await _jukebox.initialize();
  }

  @override
  void dispose() {
    _jukebox.dispose();
    _audioController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _jukebox.startPlaying();
      _isPlaying = true;
    });
  }

  void _pause() {
    setState(() {
      _jukebox.pause();
      _isPlaying = false;
    });
  }

  void _stop() {
    setState(() {
      _jukebox.stop();
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isPlaying)
          ElevatedButton(onPressed: _start, child: const Text('Start Playing'))
        else ...[
          ElevatedButton(onPressed: _pause, child: const Text('Pause')),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _stop, child: const Text('Stop')),
        ],
      ],
    );
  }
}
