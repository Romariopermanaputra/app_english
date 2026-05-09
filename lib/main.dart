import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart'; // ✨ Komentar dulu, nanti aktifkan
import 'package:supabase_flutter/supabase_flutter.dart'; // ☁️ Cloud sync

// 📁 Import screens — KOMENTARI yang file-nya BELUM ADA
import 'screens/home_screen.dart';            // ✅ Menu utama (sudah ada)
// import 'screens/grade_selection_screen.dart'; // ❌ Belum ada → komentar
import 'screens/level_map_screen.dart';       // ❌ Belum ada → komentar
// import 'screens/listening_screen.dart';       // ❌ Belum ada → komentar
// import 'screens/writing_screen.dart';         // ❌ Belum ada → komentar
// import 'screens/speaking_screen.dart';        // ❌ Belum ada → komentar
// import 'screens/leaderboard_screen.dart';     // ❌ Belum ada → komentar
// import 'screens/settings_screen.dart';        // ❌ Belum ada → komentar

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jqfoqxrtbkoojkiwjwgo.supabase.co',
    anonKey: 'sb_publishable_3oQOWXT5hMgkc5GstSqNEw_at1AqBXr',
  );
  
  runApp(const EngLearnApp());
}

class EngLearnApp extends StatelessWidget {
  const EngLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EngLearn',
      debugShowCheckedModeBanner: false,
      
      // 🎨 Tema sederhana (font custom dikomentar dulu)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        // fontFamily: 'Fredoka', // ❌ Komentar dulu, nanti aktifkan setelah font didaftar
      ),
      
      // 🏠 HomeScreen yang SUDAH ADA & working
      home: const HomeScreen(),
      
      // 🗺️ Routes — KOMENTARI yang screen-nya belum dibuat
      routes: {
        '/home': (context) => const HomeScreen(),        // ✅ Sudah ada
        '/level-map': (context) => const LevelMapScreen(),   // ❌ Belum ada
        // '/listening': (context) => const ListeningScreen(),  // ❌ Belum ada
        // '/writing': (context) => const WritingScreen(),      // ❌ Belum ada
        // '/speaking': (context) => const SpeakingScreen(),    // ❌ Belum ada
        // '/leaderboard': (context) => const LeaderboardScreen(), // ❌ Belum ada
        // '/settings': (context) => const SettingsScreen(),    // ❌ Belum ada
      },
    );
  }
}