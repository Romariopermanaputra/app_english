import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  AudioManager._internal();
  static final AudioManager instance = AudioManager._internal();

  static const String _musicEnabledKey = 'music_enabled';
  static const String _sfxEnabledKey = 'sfx_enabled';
  static const String _musicVolumeKey = 'music_volume';
  static const String _sfxVolumeKey = 'sfx_volume';

  static const String bgMusicAsset = 'audio/bg_music.mp3';
  static const String clickSfxAsset = 'audio/click.mp3';
  static const String correctSfxAsset = 'audio/correct.mp3';
  static const String wrongSfxAsset = 'audio/wrong.mp3';

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool musicEnabled = true;
  bool sfxEnabled = true;
  double musicVolume = 0.7;
  double sfxVolume = 0.8;

  Future<void> init() async {
    await loadSettings();
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    musicEnabled = prefs.getBool(_musicEnabledKey) ?? true;
    sfxEnabled = prefs.getBool(_sfxEnabledKey) ?? true;
    musicVolume = prefs.getDouble(_musicVolumeKey) ?? 0.7;
    sfxVolume = prefs.getDouble(_sfxVolumeKey) ?? 0.8;
  }

  Future<void> playBackgroundMusic() async {
    if (!musicEnabled) return;

    await _bgPlayer.setSource(AssetSource(bgMusicAsset));
    await _bgPlayer.setVolume(musicVolume);
    await _bgPlayer.resume();
  }

  Future<void> stopBackgroundMusic() async {
    await _bgPlayer.pause();
  }

  Future<void> playSoundEffect(String asset) async {
    if (!sfxEnabled) return;

    await _sfxPlayer.setSource(AssetSource(asset));
    await _sfxPlayer.setVolume(sfxVolume);
    await _sfxPlayer.resume();
  }

  Future<void> playClickSound() async {
    await playSoundEffect(clickSfxAsset);
  }

  Future<void> playCorrectSound() async {
    await playSoundEffect(correctSfxAsset);
  }

  Future<void> playWrongSound() async {
    await playSoundEffect(wrongSfxAsset);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicEnabledKey, enabled);
    if (enabled) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    sfxEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sfxEnabledKey, enabled);
  }

  Future<void> setMusicVolume(double volume) async {
    musicVolume = volume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, volume);
    await _bgPlayer.setVolume(musicVolume);
  }

  Future<void> setSfxVolume(double volume) async {
    sfxVolume = volume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sfxVolumeKey, volume);
  }

  Future<void> dispose() async {
    await _bgPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
