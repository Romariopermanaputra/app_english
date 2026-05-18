import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _musicEnabled = true;
  bool _soundEffectEnabled = true;
  bool _notificationEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
    _loadSettings();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicEnabled       = prefs.getBool('music_enabled') ?? true;
      _soundEffectEnabled = prefs.getBool('sfx_enabled') ?? true;
      _notificationEnabled = prefs.getBool('notif_enabled') ?? true;
      _musicVolume        = prefs.getDouble('music_volume') ?? 0.7;
      _sfxVolume          = prefs.getDouble('sfx_volume') ?? 0.8;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _musicEnabled        = true;
      _soundEffectEnabled  = true;
      _notificationEnabled = true;
      _musicVolume         = 0.7;
      _sfxVolume           = 0.8;
    });
    // Reset bahasa ke default (id)
    await AppLanguage().setLanguage('id');

    if (mounted) {
      final lang = AppLanguage().language;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('reset_snack', lang)),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder agar settings screen rebuild saat bahasa berubah
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        final s    = (String key) => AppStrings.get(key, lang);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.brown, size: 18),
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // 🖼️ Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFDF5E6)),
                ),
              ),

              // 🌫️ Overlay
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),

              // 📱 KONTEN
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Judul
                        Center(
                          child: Column(
                            children: [
                              const Icon(Icons.settings, color: Colors.white, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                s('settings_title'),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ─── 🎵 MUSIK ────────────────────────────────────
                        _sectionCard(
                          title: s('section_music'),
                          children: [
                            _toggleTile(
                              label:    s('bg_music'),
                              subtitle: s('bg_music_sub'),
                              icon:     Icons.music_note,
                              iconColor: Colors.purple,
                              value:    _musicEnabled,
                              onChanged: (val) {
                                setState(() => _musicEnabled = val);
                                _saveBool('music_enabled', val);
                              },
                            ),
                            if (_musicEnabled) ...[
                              const Divider(height: 1),
                              _volumeSlider(
                                label:    s('music_volume'),
                                icon:     Icons.volume_up,
                                iconColor: Colors.purple,
                                value:    _musicVolume,
                                onChanged: (val) {
                                  setState(() => _musicVolume = val);
                                  _saveDouble('music_volume', val);
                                },
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ─── 🔊 SOUND EFFECT ─────────────────────────────
                        _sectionCard(
                          title: s('section_sfx'),
                          children: [
                            _toggleTile(
                              label:    s('sound_effect'),
                              subtitle: s('sfx_sub'),
                              icon:     Icons.surround_sound,
                              iconColor: Colors.orange,
                              value:    _soundEffectEnabled,
                              onChanged: (val) {
                                setState(() => _soundEffectEnabled = val);
                                _saveBool('sfx_enabled', val);
                              },
                            ),
                            if (_soundEffectEnabled) ...[
                              const Divider(height: 1),
                              _volumeSlider(
                                label:    s('sfx_volume'),
                                icon:     Icons.graphic_eq,
                                iconColor: Colors.orange,
                                value:    _sfxVolume,
                                onChanged: (val) {
                                  setState(() => _sfxVolume = val);
                                  _saveDouble('sfx_volume', val);
                                },
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ─── 🔔 NOTIFIKASI ───────────────────────────────
                        _sectionCard(
                          title: s('section_notif'),
                          children: [
                            _toggleTile(
                              label:    s('daily_notif'),
                              subtitle: s('daily_notif_sub'),
                              icon:     Icons.notifications_active,
                              iconColor: Colors.red,
                              value:    _notificationEnabled,
                              onChanged: (val) {
                                setState(() => _notificationEnabled = val);
                                _saveBool('notif_enabled', val);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ─── 🌐 BAHASA ────────────────────────────────────
                        _sectionCard(
                          title: s('section_language'),
                          children: [
                            _languageTile(label: s('lang_id'), value: 'id', lang: lang),
                            const Divider(height: 1),
                            _languageTile(label: s('lang_en'), value: 'en', lang: lang),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ─── 👤 AKUN ──────────────────────────────────────
                        _sectionCard(
                          title: s('section_account'),
                          children: [
                            _accountTile(s),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _showResetDialog(s),
                            icon: const Icon(Icons.restore, color: Colors.white),
                            label: Text(
                              s('reset_btn'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            s('version'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── WIDGET HELPERS ──────────────────────────────────────────────

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _toggleTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.15),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      activeColor: Colors.green.shade600,
      onChanged: onChanged,
    );
  }

  Widget _volumeSlider({
    required String label,
    required IconData icon,
    required Color iconColor,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(
                      '${(value * 100).round()}%',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: iconColor),
                    ),
                  ],
                ),
                Slider(
                  value: value,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  activeColor: iconColor,
                  inactiveColor: iconColor.withOpacity(0.2),
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageTile({
    required String label,
    required String value,
    required String lang,
  }) {
    final bool isSelected = lang == value;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.green.shade700 : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Colors.green.shade600)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () => AppLanguage().setLanguage(value), // 🌐 langsung ubah bahasa global
    );
  }

  void _showResetDialog(String Function(String) s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s('reset_title')),
        content: Text(s('reset_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(s('reset_confirm'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── AKUN ────────────────────────────────────────────────────────

  Widget _accountTile(String Function(String) s) {
    // Ambil email: coba dari Supabase dulu, fallback ke SharedPreferences
    String email;
    try {
      email = Supabase.instance.client.auth.currentUser?.email ?? '-';
    } catch (_) {
      email = '-';
    }

    return FutureBuilder<String>(
      future: email == '-' ? AuthService().getCurrentEmail() : Future.value(email),
      builder: (context, snapshot) {
        final displayEmail = snapshot.data ?? email;
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.15),
                child: const Icon(Icons.person, color: Colors.green, size: 22),
              ),
              title: Text(
                s('logged_in_as'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              subtitle: Text(
                displayEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.12),
                child: const Icon(Icons.logout, color: Colors.red, size: 22),
              ),
              title: Text(
                s('logout_btn'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () => _showLogoutDialog(s),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(String Function(String) s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s('logout_title')),
        content: Text(s('logout_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _logout(s);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              s('logout_confirm'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(String Function(String) s) async {
    try {
      await AuthService().signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
