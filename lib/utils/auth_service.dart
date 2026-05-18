import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper auth yang mencoba Supabase terlebih dahulu.
/// Jika Supabase tidak tersedia (URL salah/tidak aktif), 
/// fallback ke local auth berbasis SharedPreferences.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const _keyIsLoggedIn = 'local_auth_logged_in';
  static const _keyEmail      = 'local_auth_email';
  static const _keyPassword   = 'local_auth_password'; // hash sederhana (dev only)

  bool _supabaseAvailable = true;

  // ─── Cek apakah Supabase tersedia ────────────────────────────────
  Future<bool> _checkSupabase() async {
    try {
      // Coba ping ringan: ambil session saat ini
      Supabase.instance.client.auth.currentSession;
      return true;
    } catch (_) {
      _supabaseAvailable = false;
      return false;
    }
  }

  // ─── Cek apakah user sudah login ─────────────────────────────────
  Future<bool> isLoggedIn() async {
    // Cek Supabase session dulu
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) return true;
    } catch (_) {}

    // Fallback: cek local SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ─── Ambil email user yang sedang login ──────────────────────────
  Future<String> getCurrentEmail() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user?.email != null) return user!.email!;
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '-';
  }

  // ─── LOGIN ────────────────────────────────────────────────────────
  Future<AuthResult> signIn(String email, String password) async {
    // Coba Supabase auth
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _supabaseAvailable = true;
      return AuthResult(success: true);
    } on AuthException catch (e) {
      // Supabase ada tapi error auth (email salah, dll)
      _supabaseAvailable = true;
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      // Supabase tidak tersedia → gunakan local auth
      _supabaseAvailable = false;
      debugPrint('⚠️ Supabase tidak tersedia, pakai local auth: $e');
      return _localSignIn(email, password);
    }
  }

  // ─── REGISTER ─────────────────────────────────────────────────────
  Future<AuthResult> signUp(String email, String password) async {
    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      _supabaseAvailable = true;
      // Jika email confirmation dimatikan, langsung login
      if (res.session != null) {
        return AuthResult(success: true, isNewUser: true);
      }
      // Email confirmation diperlukan
      return AuthResult(
        success: true,
        isNewUser: true,
        needsEmailConfirmation: true,
      );
    } on AuthException catch (e) {
      _supabaseAvailable = true;
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      // Supabase tidak tersedia → simpan ke local
      _supabaseAvailable = false;
      debugPrint('⚠️ Supabase tidak tersedia, pakai local register: $e');
      return _localSignUp(email, password);
    }
  }

  // ─── LOGOUT ───────────────────────────────────────────────────────
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}

    // Hapus local session juga
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyEmail);
  }

  // ─── LOCAL AUTH (fallback) ────────────────────────────────────────
  Future<AuthResult> _localSignIn(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail    = prefs.getString(_keyEmail) ?? '';
    final savedPassword = prefs.getString(_keyPassword) ?? '';

    if (savedEmail.isEmpty) {
      return AuthResult(success: false, error: 'Akun tidak ditemukan. Silakan daftar dulu.');
    }
    if (email != savedEmail || password != savedPassword) {
      return AuthResult(success: false, error: 'Email atau kata sandi salah.');
    }

    await prefs.setBool(_keyIsLoggedIn, true);
    return AuthResult(success: true);
  }

  Future<AuthResult> _localSignUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Cek apakah email sudah terdaftar
    final savedEmail = prefs.getString(_keyEmail) ?? '';
    if (savedEmail == email) {
      return AuthResult(success: false, error: 'Email sudah terdaftar.');
    }

    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    await prefs.setBool(_keyIsLoggedIn, true);
    return AuthResult(success: true, isNewUser: true);
  }

  bool get isSupabaseAvailable => _supabaseAvailable;
}

/// Hasil operasi auth
class AuthResult {
  final bool success;
  final String? error;
  final bool isNewUser;
  final bool needsEmailConfirmation;

  AuthResult({
    required this.success,
    this.error,
    this.isNewUser = false,
    this.needsEmailConfirmation = false,
  });
}
