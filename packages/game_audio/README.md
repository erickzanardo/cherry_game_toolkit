# Game Audio

Provides classes to control and play music and audio effects in games.

On app start:

```dart
  final audioController = AudioController();
  await audioController.initialize();

  final jukebox = Jukebox(
    audioController: audioController,
    musics: // you musics,
  );
  await jukebox.initialize();

  
  final sfx = SfxService(audioController: audioController);
  await sfx.precache();
```
