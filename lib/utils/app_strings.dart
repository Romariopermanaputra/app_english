/// Semua string UI dalam dua bahasa: 'id' (Indonesia) dan 'en' (English)
class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    // ─── INDONESIA ──────────────────────────────────────────────────
    'id': {
      // Home Screen
      'welcome':      'Selamat Datang di',
      'app_title':    'ENGLEARN',
      'start_game':   'MULAI GAME',
      'leaderboard':  'PERINGKAT',
      'settings':     'PENGATURAN',
      'exit':         'KELUAR',

      // Level Map Screen
      'choose_level': 'Pilih',
      'adventure':    'PETUALANGAN',
      'level_1':      'Level 1',
      'level_2':      'Level 2',
      'level_3':      'Level 3',

      // Settings Screen — judul seksi
      'settings_title':       'PENGATURAN',
      'section_music':        '🎵 Musik',
      'section_sfx':          '🔊 Sound Effect',
      'section_notif':        '🔔 Notifikasi',
      'section_language':     '🌐 Bahasa Antarmuka',
      'section_account':      '👤 Akun',

      // Settings Screen — item
      'bg_music':             'Musik Latar',
      'bg_music_sub':         'Musik yang dimainkan di background',
      'music_volume':         'Volume Musik',
      'sound_effect':         'Sound Effect',
      'sfx_sub':              'Suara saat menjawab soal dan tombol',
      'sfx_volume':           'Volume SFX',
      'daily_notif':          'Notifikasi Harian',
      'daily_notif_sub':      'Ingatkan belajar setiap hari',
      'lang_id':              '🇮🇩  Bahasa Indonesia',
      'lang_en':              '🇬🇧  English',
      'reset_btn':            'Reset ke Default',
      'logout_btn':           'Keluar Akun',
      'logged_in_as':         'Masuk sebagai',

      // Dialog reset
      'reset_title':          'Reset Pengaturan',
      'reset_msg':            'Semua pengaturan akan dikembalikan ke nilai default. Lanjutkan?',
      'cancel':               'Batal',
      'reset_confirm':        'Reset',
      'reset_snack':          '⚙️ Pengaturan direset ke default!',

      // Dialog logout
      'logout_title':         'Keluar Akun',
      'logout_msg':           'Apakah kamu yakin ingin keluar dari akun ini?',
      'logout_confirm':       'Keluar',

      // Login Screen
      'login_title':          'Masuk',
      'register_title':       'Daftar',
      'email_hint':           'Email',
      'password_hint':        'Kata Sandi',
      'confirm_password':     'Konfirmasi Kata Sandi',
      'login_btn':            'MASUK',
      'register_btn':         'DAFTAR',
      'no_account':           'Belum punya akun? ',
      'have_account':         'Sudah punya akun? ',
      'register_link':        'Daftar',
      'login_link':           'Masuk',
      'login_success':        '✅ Berhasil masuk!',
      'register_success':     '✅ Pendaftaran berhasil! Cek email untuk verifikasi.',
      'logout_success':       '👋 Berhasil keluar!',
      'field_empty':          'Email dan kata sandi tidak boleh kosong.',
      'password_mismatch':    'Kata sandi tidak cocok.',
      'password_short':       'Kata sandi minimal 6 karakter.',

      // Versi
      'version':              'EngLearn v1.0.0',
    },

    // ─── ENGLISH ─────────────────────────────────────────────────────
    'en': {
      // Home Screen
      'welcome':      'Welcome to',
      'app_title':    'ENGLEARN',
      'start_game':   'START GAME',
      'leaderboard':  'LEADERBOARD',
      'settings':     'SETTINGS',
      'exit':         'EXIT',

      // Level Map Screen
      'choose_level': 'Choose Your',
      'adventure':    'ADVENTURE',
      'level_1':      'Level 1',
      'level_2':      'Level 2',
      'level_3':      'Level 3',

      // Settings Screen — section titles
      'settings_title':       'SETTINGS',
      'section_music':        '🎵 Music',
      'section_sfx':          '🔊 Sound Effect',
      'section_notif':        '🔔 Notifications',
      'section_language':     '🌐 Interface Language',
      'section_account':      '👤 Account',

      // Settings Screen — items
      'bg_music':             'Background Music',
      'bg_music_sub':         'Music played in the background',
      'music_volume':         'Music Volume',
      'sound_effect':         'Sound Effect',
      'sfx_sub':              'Sounds when answering and pressing buttons',
      'sfx_volume':           'SFX Volume',
      'daily_notif':          'Daily Reminder',
      'daily_notif_sub':      'Remind to study every day',
      'lang_id':              '🇮🇩  Bahasa Indonesia',
      'lang_en':              '🇬🇧  English',
      'reset_btn':            'Reset to Default',
      'logout_btn':           'Sign Out',
      'logged_in_as':         'Signed in as',

      // Reset dialog
      'reset_title':          'Reset Settings',
      'reset_msg':            'All settings will be reset to default values. Continue?',
      'cancel':               'Cancel',
      'reset_confirm':        'Reset',
      'reset_snack':          '⚙️ Settings reset to default!',

      // Logout dialog
      'logout_title':         'Sign Out',
      'logout_msg':           'Are you sure you want to sign out of this account?',
      'logout_confirm':       'Sign Out',

      // Login Screen
      'login_title':          'Sign In',
      'register_title':       'Register',
      'email_hint':           'Email',
      'password_hint':        'Password',
      'confirm_password':     'Confirm Password',
      'login_btn':            'SIGN IN',
      'register_btn':         'REGISTER',
      'no_account':           "Don't have an account? ",
      'have_account':         'Already have an account? ',
      'register_link':        'Register',
      'login_link':           'Sign In',
      'login_success':        '✅ Signed in successfully!',
      'register_success':     '✅ Registration successful! Check your email to verify.',
      'logout_success':       '👋 Signed out successfully!',
      'field_empty':          'Email and password cannot be empty.',
      'password_mismatch':    'Passwords do not match.',
      'password_short':       'Password must be at least 6 characters.',

      // Version
      'version':              'EngLearn v1.0.0',
    },
  };

  /// Ambil string berdasarkan key dan bahasa yang aktif
  static String get(String key, String language) {
    return _strings[language]?[key] ?? _strings['id']?[key] ?? key;
  }
}
