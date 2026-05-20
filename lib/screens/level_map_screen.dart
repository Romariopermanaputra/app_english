import 'package:flutter/material.dart';
import '../screens/writing_screen.dart';
import '../screens/speaking_screen.dart';
import '../screens/reading_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/progress_manager.dart'; // ← Import ProgressManager

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
  int _unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    print('🔧 [DEBUG] LevelMapScreen initialized');

    const duration = Duration(milliseconds: 300);
    _level1Controller = AnimationController(vsync: this, duration: duration);
    _level2Controller = AnimationController(vsync: this, duration: duration);
    _level3Controller = AnimationController(vsync: this, duration: duration);

    _loadProgress(); // ← Load progress dari storage
    _debugCheckAsset();
  }

  // ← Method untuk load progress dari storage
  Future<void> _loadProgress() async {
    print('🔄 [LevelMap] _loadProgress() called');
    try {
      final level = await ProgressManager.getCurrentUnlockedLevel();
      print('📦 [LevelMap] Loaded level: $level');
      if (mounted) {
        setState(() {
          _unlockedLevel = level;
          print('✨ [LevelMap] UI updated: _unlockedLevel = $_unlockedLevel');
        });
      }
    } catch (e) {
      print('❌ [LevelMap] Error in _loadProgress: $e');
    }
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

  // ✅ UPDATED: _onLevelPressed - Menggunakan if-else langsung (tanpa variabel targetScreen)
  void _onLevelPressed(
    String levelName,
    AnimationController controller,
    int levelNumber,
  ) {
    print(
      '👆 [LevelMap] Tapped: $levelName (number: $levelNumber), unlocked: $_unlockedLevel',
    );

    // 🔒 CEK: Apakah level ini masih terkunci?
    if (levelNumber > _unlockedLevel) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🔒 Selesaikan Level ${levelNumber - 1} terlebih dahulu!',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      print('🔒 [LevelMap] Blocked: level $levelNumber > $_unlockedLevel');
      return; // ⛔ Jangan lanjutkan navigasi jika terkunci
    }

    print('✅ [LevelMap] Level $levelNumber unlocked, proceeding...');

    // 🎬 Jalankan animasi spring terlebih dahulu
    controller.forward().then((_) {
      Future.delayed(
        const Duration(milliseconds: 150),
        () => controller.reverse(),
      );
    });

    // 🚀 Navigasi ke screen tujuan setelah animasi selesai
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) {
        print('❌ [LevelMap] Widget not mounted, cancel navigation');
        return;
      }

      // ✅ Gunakan if-else langsung tanpa variabel perantara agar aman dari error tipe data
      if (levelName == 'Level 1') {
        print('📖 Buka modul Reading');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReadingScreen()),
        ).then((_) {
          // 🔄 PENTING: Refresh progress setelah user kembali dari screen soal
          print('🔙 [LevelMap] Returned from Reading, refreshing progress...');
          _loadProgress();
        });
      } else if (levelName == 'Level 2') {
        print('✍️ Buka modul Writing');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WritingScreen()),
        ).then((_) {
          print('🔙 [LevelMap] Returned from Writing, refreshing progress...');
          _loadProgress();
        });
      } else if (levelName == 'Level 3') {
        print('🎤 Buka modul Speaking');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SpeakingScreen()),
        ).then((_) {
          print('🔙 [LevelMap] Returned from Speaking, refreshing progress...');
          _loadProgress();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        final s = (String key) => AppStrings.get(key, lang);

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
                        _springLevelButton(
                          s('level_1'),
                          Icons.menu_book,
                          Colors.blue.shade700,
                          _level1Controller,
                          1,
                        ),
                        const SizedBox(height: 25),
                        _springLevelButton(
                          s('level_2'),
                          Icons.edit,
                          Colors.green.shade700,
                          _level2Controller,
                          2,
                        ),
                        const SizedBox(height: 25),
                        _springLevelButton(
                          s('level_3'),
                          Icons.mic,
                          Colors.orange.shade700,
                          _level3Controller,
                          3,
                        ),
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
    int levelNumber,
  ) {
    final isLocked = levelNumber > _unlockedLevel;

    return GestureDetector(
      onTapDown: isLocked
          ? null
          : (_) => _onLevelPressed(text, controller, levelNumber),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.scale(
              scale: isLocked ? 0.95 : 0.95 + (controller.value * 0.15),
              child: child,
            ),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey.shade400 : color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isLocked ? 0.1 : 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(icon, color: Colors.white, size: 30),
                  if (isLocked)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: isLocked ? Colors.grey.shade600 : Colors.brown,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isLocked) const Text('🔒', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
