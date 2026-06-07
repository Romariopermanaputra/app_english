import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static String _getKey(int classNumber) {
    return 'current_unlocked_level_class_$classNumber';
  }

  // ✅ Dapatkan level tertinggi yang sudah terbuka (default: 1)
  static Future<int> getCurrentUnlockedLevel(int classNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final level = prefs.getInt(_getKey(classNumber)) ?? 1;
      print('📦 [ProgressManager] Loaded: level $level for class $classNumber');
      return level;
    } catch (e) {
      print('❌ [ProgressManager] Error loading: $e');
      return 1; // fallback ke level 1 jika error
    }
  }

  // ✅ Update level yang sudah selesai dikerjakan
  static Future<void> completeLevel(int classNumber, int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getCurrentUnlockedLevel(classNumber);

      print(
        '🔍 [ProgressManager] completeLevel($level): current=$current for class $classNumber',
      );

      if (level >= current) {
        final newLevel = level + 1;
        await prefs.setInt(_getKey(classNumber), newLevel);

        // ✅ Verifikasi bahwa data benar-benar tersimpan
        final verify = prefs.getInt(_getKey(classNumber));
        print('✅ [ProgressManager] Saved: $verify (expected: $newLevel)');
      } else {
        print('⚠️ [ProgressManager] No update needed: $level < $current');
      }
    } catch (e) {
      print('❌ [ProgressManager] Error saving: $e');
    }
  }

  // ✅ Reset progress (untuk testing)
  static Future<void> resetProgress(int classNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_getKey(classNumber), 1);
    print(
      '🔄 [ProgressManager] Progress reset to level 1 for class $classNumber',
    );
  }
}
