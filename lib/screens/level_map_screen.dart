import 'package:flutter/material.dart';
import '../screens/writing_screen.dart';
import '../screens/speaking_screen.dart';
import '../screens/reading_screen.dart';
import '../utils/audio_manager.dart';
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
    AudioManager.instance.playClickSound();

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
            builder: (context) => ReadingScreen(
              chapter: widget.chapter,
              classNumber: widget.classNumber,
            ),
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
            builder: (context) => WritingScreen(
              chapter: widget.chapter,
              classNumber: widget.classNumber,
            ),
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
            builder: (context) => SpeakingScreen(
              chapter: widget.chapter,
              classNumber: widget.classNumber,
            ),
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
          // 🗝️ APP BAR DENGAN TOMBOL BACK
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) {
                final responsive = context.responsive;
                return Padding(
                  padding: EdgeInsets.all(responsive.spacing12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
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
                        color: Colors.white,
                        size: responsive.iconSizeSmall,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                      padding: EdgeInsets.all(responsive.spacing8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                );
              },
            ),
          ),
          extendBodyBehindAppBar: true,

          body: Stack(
            children: [
              // 🎨 GRADIENT BACKGROUND - WARNA CERAH UNTUK ANAK SD
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667EEA), // Biru muda
                        Color(0xFF764BA2), // Ungu
                        Color(0xFFF093FB), // Pink
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/ENGLearn.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ [ERROR] Gagal load background: $error');
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                              Color(0xFFF093FB),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 📱 KONTEN UTAMA
              SafeArea(
                child: Builder(
                  builder: (context) {
                    final responsive = context.responsive;
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacing20,
                        vertical: responsive.spacing24,
                      ),
                      children: [
                        SizedBox(height: responsive.spacing40),

                        // 🎨 HEADER DENGAN EMOJI
                        Text(
                          '🚀 ${s('choose_level_title')} 🚀',
                          textAlign: TextAlign.center,
                          style: responsive.getTextStyle(
                            size: TextSize.heading,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: responsive.spacing16),

                        // 📊 PROGRESS INDICATOR
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.spacing12,
                            vertical: responsive.spacing8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              responsive.radiusLarge,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${s('level_subtitle')} • 📚 ${s('chapter')} ${widget.chapter}',
                            textAlign: TextAlign.center,
                            style: responsive.getTextStyle(
                              size: TextSize.body,
                              color: Colors.white.withOpacity(0.95),
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing8),

                        // 🏆 LEVEL PROGRESS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i <= 3; i++)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.spacing4,
                                ),
                                child: Container(
                                  width: responsive.spacing12 * 1.2,
                                  height: responsive.spacing12 * 1.2,
                                  decoration: BoxDecoration(
                                    color: i <= _unlockedLevel
                                        ? Colors.amber
                                        : Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      if (i <= _unlockedLevel)
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.6),
                                          blurRadius: 8,
                                        ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      i <= _unlockedLevel ? '⭐' : '○',
                                      style: TextStyle(
                                        fontSize: responsive.fontSizeSmall,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: responsive.spacing32),

                        // 🎮 LEVEL CARDS - DESIGN YANG LEBIH MENARIK UNTUK ANAK SD
                        _buildLevelCard(
                          context: context,
                          levelName: s('level_1'),
                          icon: Icons.menu_book,
                          emoji: '📖',
                          color: const Color(0xFF4A90E2),
                          controller: _level1Controller,
                          levelNumber: 1,
                          description: 'Baca cerita seru!',
                        ),
                        SizedBox(height: responsive.spacing20),
                        _buildLevelCard(
                          context: context,
                          levelName: s('level_2'),
                          icon: Icons.edit,
                          emoji: '✏️',
                          color: const Color(0xFF50C878),
                          controller: _level2Controller,
                          levelNumber: 2,
                          description: 'Tulis kalimat baru!',
                        ),
                        SizedBox(height: responsive.spacing20),
                        _buildLevelCard(
                          context: context,
                          levelName: s('level_3'),
                          icon: Icons.mic,
                          emoji: '🎤',
                          color: const Color(0xFFFFB84D),
                          controller: _level3Controller,
                          levelNumber: 3,
                          description: 'Bicara dengan percaya diri!',
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

  // � CARD LEVEL BARU - DESIGN YANG LEBIH MENARIK UNTUK ANAK SD
  Widget _buildLevelCard({
    required BuildContext context,
    required String levelName,
    required IconData icon,
    required String emoji,
    required Color color,
    required AnimationController controller,
    required int levelNumber,
    required String description,
  }) {
    final isLocked = levelNumber > _unlockedLevel;

    return Builder(
      builder: (context) {
        final responsive = context.responsive;
        return GestureDetector(
          onTap: isLocked
              ? () {
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
              : () => _onLevelPressed(levelName, controller, levelNumber),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.scale(
              scale: isLocked ? 1 : (1 - (controller.value * 0.08)),
              child: Transform.translate(
                offset: isLocked
                    ? Offset.zero
                    : Offset(0, -(controller.value * 8)),
                child: child,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(responsive.spacing16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isLocked
                      ? [Colors.grey.shade300, Colors.grey.shade400]
                      : [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(responsive.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: isLocked
                        ? Colors.black.withOpacity(0.1)
                        : color.withOpacity(0.4),
                    blurRadius: 16,
                    offset: Offset(0, responsive.spacing8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // 🎯 EMOJI BESAR
                  Container(
                    width: responsive.spacing24 * 2.5,
                    height: responsive.spacing24 * 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Icon atau Lock
                        if (isLocked)
                          Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: responsive.iconSizeMedium,
                          )
                        else
                          Text(
                            emoji,
                            style: TextStyle(fontSize: responsive.spacing24),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: responsive.spacing16),

                  // 📝 KONTEN TEKS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          levelName,
                          style: responsive.getTextStyle(
                            size: TextSize.bodyLarge,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: responsive.spacing4),
                        Text(
                          description,
                          style: responsive.getTextStyle(
                            size: TextSize.body,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        if (isLocked)
                          Padding(
                            padding: EdgeInsets.only(top: responsive.spacing4),
                            child: Text(
                              '🔒 Terkunci',
                              style: responsive.getTextStyle(
                                size: TextSize.small,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ✨ ICON PLAY
                  if (!isLocked)
                    Container(
                      width: responsive.spacing20 * 1.5,
                      height: responsive.spacing20 * 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: responsive.iconSizeSmall,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ⬇️ WIDGET LAMA (DIHAPUS DI BAWAH INI)
  Widget _springLevelButton(
    String text,
    IconData icon,
    Color color,
    AnimationController controller,
    int levelNumber,
  ) {
    final isLocked = levelNumber > _unlockedLevel;

    return Builder(
      builder: (context) {
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
                      Icon(
                        icon,
                        color: Colors.white,
                        size: responsive.iconSizeLarge,
                      ),
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
                Text(
                  '🔒',
                  style: TextStyle(fontSize: responsive.fontSizeSmall),
                ),
            ],
          ),
        );
      },
    );
  }
}
