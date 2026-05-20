import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static const String _keyCurrentLevel = 'current_unlocked_level';

  // ✅ Dapatkan level tertinggi yang sudah terbuka (default: 1)
  static Future<int> getCurrentUnlockedLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final level = prefs.getInt(_keyCurrentLevel) ?? 1;
      print('📦 [ProgressManager] Loaded: level $level');
      return level;
    } catch (e) {
      print('❌ [ProgressManager] Error loading: $e');
      return 1; // fallback ke level 1 jika error
    }
  }

  // ✅ Update level yang sudah selesai dikerjakan
  static Future<void> completeLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getCurrentUnlockedLevel();

      print('🔍 [ProgressManager] completeLevel($level): current=$current');

      if (level >= current) {
        final newLevel = level + 1;
        await prefs.setInt(_keyCurrentLevel, newLevel);

        // ✅ Verifikasi bahwa data benar-benar tersimpan
        final verify = prefs.getInt(_keyCurrentLevel);
        print('✅ [ProgressManager] Saved: $verify (expected: $newLevel)');
      } else {
        print('⚠️ [ProgressManager] No update needed: $level < $current');
      }
    } catch (e) {
      print('❌ [ProgressManager] Error saving: $e');
    }
  }

  // ✅ Reset progress (untuk testing)
  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentLevel, 1);
    print('🔄 [ProgressManager] Progress reset to level 1');
  }
}
