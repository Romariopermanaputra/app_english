import 'package:flutter/material.dart';
import '../screens/writing_screen.dart';
import '../screens/speaking_screen.dart';
import '../screens/reading_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/progress_manager.dart';
import '../utils/responsive_helper.dart';
import '../utils/audio_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelMapScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const LevelMapScreen({super.key, this.chapter = 1, this.classNumber = 4});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  int _unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    print('🔧 [DEBUG] LevelMapScreen initialized');

    const duration = Duration(milliseconds: 300);
    _controllers = List.generate(
      9,
      (index) => AnimationController(vsync: this, duration: duration),
    );

    _loadProgress(); // ← Load progress dari storage
    _debugCheckAsset();
  }

  // ← Method untuk load progress dari storage
  Future<void> _loadProgress() async {
    print('🔄 [LevelMap] _loadProgress() called');
    try {
      final level = await ProgressManager.getCurrentUnlockedLevel(widget.classNumber);
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
    for (var controller in _controllers) {
      controller.dispose();
    }
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
    AudioManager().playSfx('click.wav');
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

      // ✅ Gunakan modulo untuk menentukan tipe level
      if (levelNumber % 3 == 1) { // 1, 4, 7 -> Reading
        print('📖 Buka modul Reading (Level $levelNumber)');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadingScreen(chapter: widget.chapter, classNumber: widget.classNumber),
          ),
        ).then((_) {
          print('🔙 [LevelMap] Returned from Reading, refreshing progress...');
          _loadProgress();
        });
      } else if (levelNumber % 3 == 2) { // 2, 5, 8 -> Writing
        print('✍️ Buka modul Writing (Level $levelNumber)');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WritingScreen(chapter: widget.chapter, classNumber: widget.classNumber),
          ),
        ).then((_) {
          print('🔙 [LevelMap] Returned from Writing, refreshing progress...');
          _loadProgress();
        });
      } else if (levelNumber % 3 == 0) { // 3, 6, 9 -> Speaking
        print('🎤 Buka modul Speaking (Level $levelNumber)');
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
                    onPressed: () {
                      AudioManager().playSfx('click.wav');
                      Navigator.pop(context);
                    },
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
                          style: GoogleFonts.fredoka(
                            textStyle: responsive.getTextStyle(
                              size: TextSize.heading,
                              color: Colors.brown,
                              weight: FontWeight.w900,
                            ).copyWith(fontSize: responsive.spacing32 * 1.6),
                          ),
                        ).animate().slideY(begin: -0.5, end: 0, curve: Curves.easeOutBack, duration: 600.ms).fadeIn(),
                        SizedBox(height: responsive.spacing12),
                        Text(
                          s('level_subtitle'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            textStyle: responsive.getTextStyle(
                              size: TextSize.body,
                              color: Colors.brown.withOpacity(0.8),
                            ).copyWith(fontSize: responsive.spacing20),
                          ),
                        ),
                        SizedBox(height: responsive.spacing8),
                        Text(
                          '${s('chapter')} ${widget.chapter}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            textStyle: responsive.getTextStyle(
                              size: TextSize.bodyLarge,
                              color: Colors.brown.withOpacity(0.9),
                              weight: FontWeight.w600,
                            ).copyWith(fontSize: responsive.spacing24),
                          ),
                        ),
                        SizedBox(height: responsive.spacing40),

                        // 🔘 TOMBOL LEVEL (BULAT + TEKS DI BAWAH)
                        Center(
                          child: Wrap(
                            spacing: responsive.spacing24,
                            runSpacing: responsive.spacing32,
                            alignment: WrapAlignment.center,
                            children: List.generate(9, (index) {
                              final levelNum = index + 1;
                              
                              String label;
                              IconData iconData;
                              Color color;

                              if (levelNum % 3 == 1) {
                                label = 'Reading ${(levelNum / 3).ceil()}';
                                iconData = Icons.menu_book;
                                color = Colors.blue.shade700;
                              } else if (levelNum % 3 == 2) {
                                label = 'Writing ${(levelNum / 3).ceil()}';
                                iconData = Icons.edit;
                                color = Colors.green.shade700;
                              } else {
                                label = 'Speaking ${(levelNum / 3).ceil()}';
                                iconData = Icons.mic;
                                color = Colors.orange.shade700;
                              }

                              return _springLevelButton(
                                label,
                                iconData,
                                color,
                                _controllers[index],
                                levelNum,
                              ).animate().scale(delay: Duration(milliseconds: 100 * index), curve: Curves.elasticOut);
                            }),
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
            SizedBox(height: responsive.spacing12),
          Text(
            text,
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                color: isLocked ? Colors.grey.shade600 : Colors.brown,
                fontSize: responsive.fontSizeBody,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),  if (isLocked) 
              Text('🔒', style: TextStyle(fontSize: responsive.fontSizeSmall)),
          ],
        ),
      );
    });
  }
}
