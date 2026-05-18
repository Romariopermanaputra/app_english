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
      'logged_in_as':         'Bermain sebagai',
      'logout_btn':           'Ganti Pemain',

      // Dialog reset
      'reset_title':          'Reset Pengaturan',
      'reset_msg':            'Semua pengaturan akan dikembalikan ke nilai default. Lanjutkan?',
      'cancel':               'Batal',
      'reset_confirm':        'Reset',
      'reset_snack':          '⚙️ Pengaturan direset ke default!',

      // Dialog logout
      'logout_title':         'Ganti Pemain',
      'logout_msg':           'Keluar dari akun ini dan pilih username lain?',
      'logout_confirm':       'Keluar',

      // Login Screen
      'login_title':          'Masuk / Daftar',
      'login_subtitle':       'Ketik username-mu untuk mulai bermain!',
      'username_hint':        'Username',
      'username_empty':       'Username tidak boleh kosong.',
      'username_short':       'Username minimal 3 karakter.',
      'username_invalid':     'Username hanya boleh huruf, angka, dan underscore.',
      'login_btn':            'MULAI BERMAIN',
      'login_success':        '✅ Selamat datang kembali!',
      'register_success':     '✅ Akun baru dibuat! Selamat bermain!',
      'logout_success':       '👋 Berhasil keluar!',

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
      'logged_in_as':         'Playing as',
      'logout_btn':           'Switch Player',

      // Reset dialog
      'reset_title':          'Reset Settings',
      'reset_msg':            'All settings will be reset to default values. Continue?',
      'cancel':               'Cancel',
      'reset_confirm':        'Reset',
      'reset_snack':          '⚙️ Settings reset to default!',

      // Logout dialog
      'logout_title':         'Switch Player',
      'logout_msg':           'Sign out of this account and choose another username?',
      'logout_confirm':       'Sign Out',

      // Login Screen
      'login_title':          'Sign In / Register',
      'login_subtitle':       'Enter your username to start playing!',
      'username_hint':        'Username',
      'username_empty':       'Username cannot be empty.',
      'username_short':       'Username must be at least 3 characters.',
      'username_invalid':     'Username can only contain letters, numbers, and underscores.',
      'login_btn':            'START PLAYING',
      'login_success':        '✅ Welcome back!',
      'register_success':     '✅ New account created! Have fun!',
      'logout_success':       '👋 Signed out!',

      // Version
      'version':              'EngLearn v1.0.0',
    },
  };

  /// Ambil string berdasarkan key dan bahasa yang aktif
  static String get(String key, String language) {
    return _strings[language]?[key] ?? _strings['id']?[key] ?? key;
  }
}
