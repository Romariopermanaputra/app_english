This folder should contain audio assets used by the app (backsound, fx).

Guidelines:
- Place background music (e.g. `backsound.mp3`) here.
- Register `assets/audio/` in `pubspec.yaml` (already added).
- Use the helper in `lib/utils/audio_manager.dart` to play:

  ```dart
  // In main.dart before runApp:
  await AudioManager().init();

  // To play:
  AudioManager().playAsset('backsound.mp3', volume: 0.4);

  // To pause/stop:
  AudioManager().pause();
  AudioManager().stop();

  // Toggle mute:
  AudioManager().toggleMute();
  ```

Notes:
- Use short, optimized files (ogg/mp3) and respect licensing.
