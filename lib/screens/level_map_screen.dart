import 'package:flutter/material.dart';
import '../screens/writing_screen.dart';
import '../screens/speaking_screen.dart';
import '../screens/reading_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/progress_manager.dart';
import '../utils/responsive_helper.dart';

class LevelMapScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const LevelMapScreen({super.key, this.chapter = 1, this.classNumber = 4});

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
          MaterialPageRoute(
            builder: (context) => ReadingScreen(chapter: widget.chapter, classNumber: widget.classNumber),
          ),
        ).then((_) {
          // 🔄 PENTING: Refresh progress setelah user kembali dari screen soal
          print('🔙 [LevelMap] Returned from Reading, refreshing progress...');
          _loadProgress();
        });
      } else if (levelName == 'Level 2') {
        print('✍️ Buka modul Writing');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WritingScreen(chapter: widget.chapter, classNumber: widget.classNumber),
          ),
        ).then((_) {
          print('🔙 [LevelMap] Returned from Writing, refreshing progress...');
          _loadProgress();
        });
      } else if (levelName == 'Level 3') {
        print('🎤 Buka modul Speaking');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakingScreen(chapter: widget.chapter, classNumber: widget.classNumber),
          ),
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
        String s(String key) => AppStrings.get(key, lang);

        return Scaffold(
          // 🗝️ APP BAR DENGAN TOMBOL BACK (STYLE KOTAK PUTIH)
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(builder: (context) {
              final responsive = context.responsive;
              return Padding(
                padding: EdgeInsets.all(responsive.spacing12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, responsive.spacing4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.brown,
                      size: responsive.iconSizeSmall,
                    ),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Kembali',
                    padding: EdgeInsets.all(responsive.spacing8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              );
            }),
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
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Background tidak ditemukan',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            Text(
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
                child: Builder(
                  builder: (context) {
                    final responsive = context.responsive;
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: responsive.spacing20, vertical: responsive.spacing24),
                      children: [
                        SizedBox(height: responsive.spacing40),
                        Text(
                          s('choose_level_title'),
                          textAlign: TextAlign.center,
                          style: responsive.getTextStyle(
                            size: TextSize.heading,
                            color: Colors.brown,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: responsive.spacing8),
                        Text(
                          s('level_subtitle'),
                          textAlign: TextAlign.center,
                          style: responsive.getTextStyle(
                            size: TextSize.body,
                            color: Colors.brown.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: responsive.spacing8),
                        Text(
                          '${s('chapter')} ${widget.chapter}',
                          textAlign: TextAlign.center,
                          style: responsive.getTextStyle(
                            size: TextSize.bodyLarge,
                            color: Colors.brown.withOpacity(0.9),
                            weight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: responsive.spacing32),

                        // 🔘 TOMBOL LEVEL (BULAT + TEKS DI BAWAH)
                        Center(
                          child: _springLevelButton(
                            s('level_1'),
                            Icons.menu_book,
                            Colors.blue.shade700,
                            _level1Controller,
                            1,
                          ),
                        ),
                        SizedBox(height: responsive.spacing24),
                        Center(
                          child: _springLevelButton(
                            s('level_2'),
                            Icons.edit,
                            Colors.green.shade700,
                            _level2Controller,
                            2,
                          ),
                        ),
                        SizedBox(height: responsive.spacing24),
                        Center(
                          child: _springLevelButton(
                            s('level_3'),
                            Icons.mic,
                            Colors.orange.shade700,
                            _level3Controller,
                            3,
                          ),
                        ),
                        SizedBox(height: responsive.spacing40),
                      ],
                    );
                  },
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

    return Builder(builder: (context) {
      final responsive = context.responsive;
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
                width: responsive.spacing32 * 2.2,
                height: responsive.spacing32 * 2.2,
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
                      offset: Offset(0, responsive.spacing8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(icon, color: Colors.white, size: responsive.iconSizeLarge),
                    if (isLocked)
                      Container(
                        width: responsive.spacing32 * 2.2,
                        height: responsive.spacing32 * 2.2,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: responsive.iconSizeMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.spacing8),
            Text(
              text,
              style: responsive.getTextStyle(
                size: TextSize.body,
                color: isLocked ? Colors.grey.shade600 : Colors.brown,
                weight: FontWeight.bold,
              ),
            ),
            if (isLocked) 
              Text('🔒', style: TextStyle(fontSize: responsive.fontSizeSmall)),
          ],
        ),
      );
    });
  }
}
