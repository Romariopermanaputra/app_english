import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton ChangeNotifier — dipakai oleh semua screen
class AppLanguage extends ChangeNotifier {
  static final AppLanguage _instance = AppLanguage._internal();
  factory AppLanguage() => _instance;
  AppLanguage._internal();

  String _language = 'id'; // default: Indonesia
  String get language => _language;

  /// Panggil sekali di main() sebelum runApp
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'id';
    notifyListeners();
  }

  /// Ganti bahasa dan simpan ke SharedPreferences
  Future<void> setLanguage(String lang) async {
    if (_language == lang) return;
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }
}
