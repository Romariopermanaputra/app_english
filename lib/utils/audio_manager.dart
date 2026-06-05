import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

/// Simple singleton manager for background audio (backsound).
///
/// Usage:
/// 1. Place your audio files under `assets/audio/` and ensure
///    `pubspec.yaml` includes `- assets/audio/` (done).
/// 2. Call `await AudioManager().init()` early (for example in `main()`).
/// 3. Play: `AudioManager().playAsset('backsound.mp3', volume: 0.4);`
/// 4. Pause/stop/mute via provided methods.
class AudioManager with WidgetsBindingObserver {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  late final AudioPlayer _player;
  bool _initialized = false;
  bool _muted = false;
  double _volume = 0.5;
  String? _currentFile;

  Future<void> init() async {
    if (_initialized) return;
    WidgetsBinding.instance.addObserver(this);
    _player = AudioPlayer();
    await _player.setReleaseMode(ReleaseMode.loop);
    _initialized = true;
  }

  /// Play an asset filename located in `assets/audio/`.
  Future<void> playAsset(String filename, {double volume = 0.5}) async {
    await init();
    _volume = volume;
    _currentFile = filename;
    if (_muted) return;
    await _player.setSource(AssetSource('audio/$filename'));
    await _player.setVolume(_volume);
    await _player.resume();
  }

  Future<void> resume() async {
    if (!_initialized) await init();
    if (_muted) return;
    await _player.resume();
  }

  Future<void> pause() async {
    if (!_initialized) return;
    await _player.pause();
  }

  Future<void> stop() async {
    if (!_initialized) return;
    await _player.stop();
  }

  Future<void> setVolume(double v) async {
    _volume = v.clamp(0.0, 1.0);
    if (!_initialized) await init();
    await _player.setVolume(_muted ? 0 : _volume);
  }

  Future<void> toggleMute() async {
    _muted = !_muted;
    if (!_initialized) await init();
    await _player.setVolume(_muted ? 0 : _volume);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_initialized) return;
    if (state == AppLifecycleState.paused) {
      _player.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (!_muted) _player.resume();
    }
  }

  void dispose() {
    try {
      WidgetsBinding.instance.removeObserver(this);
    } catch (_) {}
    try {
      _player.dispose();
    } catch (_) {}
  }
}
