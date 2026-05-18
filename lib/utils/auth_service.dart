import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// AuthService berbasis USERNAME — tidak perlu email/password.
/// Data disimpan ke tabel `players` di Supabase.
/// Fallback ke SharedPreferences jika Supabase tidak tersedia.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const _keyUsername = 'current_username';
  static const _keyLoggedIn = 'is_logged_in';

  final _supabase = Supabase.instance.client;

  // ─── Cek apakah user sudah login ─────────────────────────────────
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // ─── Ambil username saat ini ──────────────────────────────────────
  Future<String> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '-';
  }

  // Alias untuk kompatibilitas dengan settings_screen
  Future<String> getCurrentEmail() => getCurrentUsername();

  // ─── LOGIN / REGISTER dengan username ────────────────────────────
  /// Jika username sudah ada → login.
  /// Jika belum ada → daftar otomatis lalu login.
  Future<AuthResult> signInWithUsername(String username) async {
    try {
      // Cek apakah username sudah ada di tabel players
      final existing = await _supabase
          .from('players')
          .select('id, username')
          .eq('username', username)
          .maybeSingle();

      bool isNewUser = false;

      if (existing == null) {
        // Belum ada → buat akun baru
        await _supabase.from('players').insert({
          'username': username,
          'created_at': DateTime.now().toIso8601String(),
        });
        isNewUser = true;
        debugPrint('✅ Akun baru dibuat: $username');
      } else {
        debugPrint('✅ Login sebagai: $username');
      }

      // Simpan sesi lokal
      await _saveSession(username);
      return AuthResult(success: true, isNewUser: isNewUser);
    } catch (e) {
      debugPrint('⚠️ Supabase error, pakai local auth: $e');
      // Fallback: simpan lokal saja
      await _saveSession(username);
      return AuthResult(success: true, isNewUser: true, usedFallback: true);
    }
  }

  // ─── LOGOUT ───────────────────────────────────────────────────────
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.setBool(_keyLoggedIn, false);
    debugPrint('👋 Logout berhasil');
  }

  // ─── SIMPAN SESI LOKAL ───────────────────────────────────────────
  Future<void> _saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyLoggedIn, true);
  }
}

/// Hasil operasi auth
class AuthResult {
  final bool success;
  final String? error;
  final bool isNewUser;
  final bool needsEmailConfirmation;
  final bool usedFallback;

  AuthResult({
    required this.success,
    this.error,
    this.isNewUser = false,
    this.needsEmailConfirmation = false,
    this.usedFallback = false,
  });
}
