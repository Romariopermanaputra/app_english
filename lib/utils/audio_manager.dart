import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late final AudioPlayer _sfxPlayer;
  bool _initialized = false;
  bool _muted = false;
  double _volume = 0.5;
  bool _sfxEnabled = true;
  double _sfxVolume = 0.8;

  Future<void> init() async {
    if (_initialized) return;
    WidgetsBinding.instance.addObserver(this);
    _player = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    await _player.setReleaseMode(ReleaseMode.loop);

    // Load settings from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _muted = !(prefs.getBool('music_enabled') ?? true);
    _volume = prefs.getDouble('music_volume') ?? 0.5;

    _sfxEnabled = prefs.getBool('sfx_enabled') ?? true;
    _sfxVolume = prefs.getDouble('sfx_volume') ?? 0.8;

    _initialized = true;
  }

  /// Play an asset filename located in `assets/audio/`.
  Future<void> playAsset(String filename, {double? volume}) async {
    await init();
    if (volume != null) _volume = volume;
    await _player.setSource(AssetSource('audio/$filename'));
    await _player.setVolume(_muted ? 0 : _volume);
    if (!_muted) {
      await _player.resume();
    }
  }

  /// Play a sound effect.
  Future<void> playSfx(String filename, {double? volume}) async {
    await init();
    if (!_sfxEnabled) return;

    final vol = volume ?? _sfxVolume;
    if (vol <= 0) return;

    // Use a fire-and-forget logic if we want overlapping, but for simple UI clicks:
    await _sfxPlayer.stop();
    await _sfxPlayer.setVolume(vol);
    await _sfxPlayer.play(AssetSource('audio/$filename'));
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

  Future<void> setSfxVolume(double v) async {
    _sfxVolume = v.clamp(0.0, 1.0);
  }

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    if (!_initialized) await init();
    await _player.setVolume(_muted ? 0 : _volume);
    if (!_muted && _player.state != PlayerState.playing) {
      await _player.resume();
    } else if (_muted && _player.state == PlayerState.playing) {
      // Keep it playing but at 0 volume so it loops in background, or pause it.
      // We set volume to 0 above, so it's fine.
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
  }

  Future<void> toggleMute() async {
    await setMuted(!_muted);
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
      _sfxPlayer.dispose();
    } catch (_) {}
  }
}
