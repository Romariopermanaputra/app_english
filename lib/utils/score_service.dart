import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

/// Model data satu sesi permainan
class GameScore {
  final String username;
  final String module; // 'reading' | 'writing' | 'speaking'
  final int classNumber;
  final int level;
  final int score;
  final int maxScore;
  final DateTime playedAt;

  GameScore({
    required this.username,
    required this.module,
    required this.classNumber,
    required this.level,
    required this.score,
    required this.maxScore,
    required this.playedAt,
  });

  int get percentage => maxScore > 0 ? ((score / maxScore) * 100).round() : 0;

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      username: json['username'] as String,
      module: json['module'] as String,
      classNumber: json['class_number'] as int? ?? 4, // Default to 4 if null
      level: json['level'] as int,
      score: json['score'] as int,
      maxScore: json['max_score'] as int,
      playedAt: DateTime.parse(json['played_at'] as String),
    );
  }
}

/// Model data untuk leaderboard — satu entry per user (agregat)
class LeaderboardEntry {
  final int rank;
  final String username;
  final int totalScore;
  final int totalMax;
  final int gamesPlayed;

  LeaderboardEntry({
    required this.rank,
    required this.username,
    required this.totalScore,
    required this.totalMax,
    required this.gamesPlayed,
  });

  int get percentage =>
      totalMax > 0 ? ((totalScore / totalMax) * 100).round() : 0;
}

/// Service untuk menyimpan dan mengambil skor dari Supabase
class ScoreService {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  final _db = Supabase.instance.client;

  // ─── Simpan skor setelah selesai game ────────────────────────────
  Future<bool> saveScore({
    required String module,
    required int classNumber,
    required int level,
    required int score,
    required int maxScore,
  }) async {
    try {
      final username = await AuthService().getCurrentUsername();
      if (username == '-' || username.isEmpty) return false;

      await _db.from('scores').insert({
        'username': username,
        'module': module,
        'class_number': classNumber,
        'level': level,
        'score': score,
        'max_score': maxScore,
        'played_at': DateTime.now().toIso8601String(),
      });

      debugPrint(
        '✅ Skor disimpan: $username | $module L$level | $score/$maxScore',
      );
      return true;
    } catch (e) {
      debugPrint('⚠️ Gagal simpan skor: $e');
      return false;
    }
  }

  // ─── Ambil data leaderboard (agregat per user) ────────────────────
  Future<List<LeaderboardEntry>> getLeaderboard(int classNumber) async {
    try {
      final res = await _db
          .from('scores')
          .select('username, module, level, score, max_score')
          .eq('class_number', classNumber);

      // 1. Dapatkan skor maksimum untuk setiap (username + module + level)
      // Key: "username|module|level" -> Map<String, int> { 'score': X, 'max_score': Y }
      final Map<String, Map<String, int>> maxScoresPerLevel = {};

      // Hitung total berapa kali tiap user main (meskipun diulang)
      final Map<String, int> gamesPlayedPerUser = {};

      for (final row in res as List<dynamic>) {
        final name = row['username'] as String;
        final module = row['module'] as String;
        final level = row['level'] as int;
        final score = row['score'] as int;
        final maxScore = row['max_score'] as int;

        gamesPlayedPerUser[name] = (gamesPlayedPerUser[name] ?? 0) + 1;

        final key = "$name|$module|$level";

        if (!maxScoresPerLevel.containsKey(key)) {
          maxScoresPerLevel[key] = {'score': score, 'max_score': maxScore};
        } else {
          // Ambil yang paling tinggi jika dimainkan berulang kali
          if (score > maxScoresPerLevel[key]!['score']!) {
            maxScoresPerLevel[key]!['score'] = score;
            maxScoresPerLevel[key]!['max_score'] = maxScore;
          }
        }
      }

      // 2. Jumlahkan skor max tersebut untuk tiap user
      final Map<String, Map<String, int>> userTotals = {};

      maxScoresPerLevel.forEach((key, value) {
        final name = key.split('|')[0];

        userTotals.putIfAbsent(name, () => {'total': 0, 'max': 0, 'games': 0});
        userTotals[name]!['total'] =
            userTotals[name]!['total']! + value['score']!;
        userTotals[name]!['max'] =
            userTotals[name]!['max']! + value['max_score']!;
      });

      // Tambahkan data games_played
      userTotals.forEach((name, data) {
        data['games'] = gamesPlayedPerUser[name] ?? 0;
      });

      // 3. Urutkan berdasarkan total score DESC
      final entries = userTotals.entries.toList()
        ..sort((a, b) => b.value['total']!.compareTo(a.value['total']!));

      return entries.asMap().entries.map((e) {
        return LeaderboardEntry(
          rank: e.key + 1,
          username: e.value.key,
          totalScore: e.value.value['total']!,
          totalMax: e.value.value['max']!,
          gamesPlayed: e.value.value['games']!,
        );
      }).toList();
    } catch (e) {
      debugPrint('⚠️ Gagal ambil leaderboard: $e');
      return [];
    }
  }

  // ─── Ambil riwayat skor satu user ─────────────────────────────────
  Future<List<GameScore>> getUserHistory(String username) async {
    try {
      final res = await _db
          .from('scores')
          .select()
          .eq('username', username)
          .order('played_at', ascending: false)
          .limit(20);

      return (res as List<dynamic>)
          .map((e) => GameScore.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('⚠️ Gagal ambil riwayat: $e');
      return [];
    }
  }
}
