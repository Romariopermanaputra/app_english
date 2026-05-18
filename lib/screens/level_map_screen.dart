import 'package:flutter/material.dart';
import '../screens/writing_screen.dart';
import '../screens/speaking_screen.dart';
import '../screens/reading_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _level1Controller;
  late AnimationController _level2Controller;
  late AnimationController _level3Controller;

  @override
  void initState() {
    super.initState();
    print('🔧 [DEBUG] LevelMapScreen initialized');

    const duration = Duration(milliseconds: 300);
    _level1Controller = AnimationController(vsync: this, duration: duration);
    _level2Controller = AnimationController(vsync: this, duration: duration);
    _level3Controller = AnimationController(vsync: this, duration: duration);

    _debugCheckAsset();
  }

  @override
  void dispose() {
    _level1Controller.dispose();
    _level2Controller.dispose();
    _level3Controller.dispose();
    super.dispose();
  }

  void _debugCheckAsset() {
    print('🔍 [DEBUG] Pastikan:');
    print('   1. File ada di: assets/images/level_map_screen.png');
    print('   2. pubspec.yaml berisi:');
    print('      flutter:');
    print('        assets:');
    print('          - images/level_map_screen.png');
    print('   3. Sudah run: flutter pub get');
  }

  void _onLevelPressed(String levelName, AnimationController controller) {
    print('👆 [DEBUG] Level ditekan: $levelName');

    // Jalankan animasi spring terlebih dahulu
    controller.forward().then((_) {
      Future.delayed(
        const Duration(milliseconds: 150),
        () => controller.reverse(),
      );
    });

    // Navigasi ke screen tujuan setelah animasi selesai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return; // Pastikan widget masih aktif

      if (levelName == 'Level 1') {
        print('📖 Buka modul Reading');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReadingScreen()),
        );
      } else if (levelName == 'Level 2') {
        print('✍️ Buka modul Writing');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WritingScreen()),
        );
      } else if (levelName == 'Level 3') {
        print('🎤 Buka modul Speaking');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SpeakingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        final s    = (String key) => AppStrings.get(key, lang);

        return Scaffold(
      // 🗝️ APP BAR DENGAN TOMBOL BACK (STYLE KOTAK PUTIH)
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.brown,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Kembali',
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          // 🖼️ BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/ENGLearn.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('❌ [ERROR] Gagal load background: $error');
                return Container(
                  color: const Color(0xFFFDF5E6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Background tidak ditemukan',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const Text(
                          'Cek terminal untuk detail error',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 📱 KONTEN UTAMA
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 🏷️ JUDUL (EFEK TRANSPARAN / WATERMARK)
                Column(
                  children: [
                    Text(
                      s('choose_level'),
                      style: TextStyle(
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.withOpacity(0.0),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.0),
                      ),
                      child: Text(
                        s('adventure'),
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.brown.withOpacity(0.0),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // 🔘 TOMBOL LEVEL (BULAT + TEKS DI BAWAH)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _springLevelButton(s('level_1'), Icons.menu_book, Colors.blue.shade700,   _level1Controller),
                    const SizedBox(height: 25),
                    _springLevelButton(s('level_2'), Icons.edit,      Colors.green.shade700,  _level2Controller),
                    const SizedBox(height: 25),
                    _springLevelButton(s('level_3'), Icons.mic,       Colors.orange.shade700, _level3Controller),
                    const SizedBox(height: 40),
                  ],
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  // 🎮 Widget Tombol Level - BULAT + TEKS DI BAWAH ✨
  Widget _springLevelButton(
    String text,
    IconData icon,
    Color color,
    AnimationController controller,
  ) {
    return GestureDetector(
      onTapDown: (_) => _onLevelPressed(text, controller),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.scale(
              scale: 0.95 + (controller.value * 0.15),
              child: child,
            ),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
