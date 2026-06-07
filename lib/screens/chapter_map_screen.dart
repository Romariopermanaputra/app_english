import 'package:flutter/material.dart';
import '../screens/level_map_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/progress_manager.dart';
import '../utils/responsive_helper.dart';
import '../utils/audio_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ChapterMapScreen extends StatefulWidget {
  final int classNumber;

  const ChapterMapScreen({super.key, this.classNumber = 4});

  @override
  State<ChapterMapScreen> createState() => _ChapterMapScreenState();
}

class _ChapterMapScreenState extends State<ChapterMapScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  int _currentUnlockedChapter = 1;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _controllers = List.generate(
      9,
      (index) => AnimationController(vsync: this, duration: duration),
    );
    _loadProgress();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProgress() async {
    try {
      final level = await ProgressManager.getCurrentUnlockedLevel(
        widget.classNumber,
      );
      final chapter = _calculateUnlockedChapter(level);
      if (mounted) {
        setState(() {
          _currentUnlockedChapter = chapter;
        });
      }
    } catch (e) {
      print('❌ [ChapterMap] Error loading progress: $e');
    }
  }

  int _calculateUnlockedChapter(int level) {
    final chapter = ((level - 1) ~/ 3) + 1;
    return chapter.clamp(1, 3);
  }

  void _onChapterPressed(int chapterNumber, AnimationController controller) {
    AudioManager().playSfx('click.wav');
    final isLocked = chapterNumber > _currentUnlockedChapter;
    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Selesaikan Chapter ${chapterNumber - 1} terlebih dahulu untuk membuka Chapter $chapterNumber.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        controller.reverse();
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LevelMapScreen(
            chapter: chapterNumber,
            classNumber: widget.classNumber,
          ),
        ),
      ).then((_) {
        _loadProgress();
      });
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
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
                        color: Colors.brown,
                        size: context.responsive.iconSizeSmall,
                      ),
                      onPressed: () {
                        AudioManager().playSfx('click.wav');
                        Navigator.pop(context);
                      },
                      tooltip: s('btn_back'),
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
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFFDF5E6)),
                ),
              ),
              SafeArea(
                child: Builder(
                  builder: (context) {
                    final responsive = context.responsive;
                    return Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.spacing20,
                            vertical: responsive.spacing24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: responsive.spacing40),
                              Text(
                                    s('choose_chapter'),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fredoka(
                                      textStyle: responsive
                                          .getTextStyle(
                                            size: TextSize.heading,
                                            color: Colors.brown,
                                            weight: FontWeight.w900,
                                          )
                                          .copyWith(
                                            fontSize: responsive.spacing32 * 1.6,
                                          ),
                                    ),
                                  )
                                  .animate()
                                  .slideY(
                                    begin: -0.5,
                                    end: 0,
                                    curve: Curves.easeOutBack,
                                    duration: 600.ms,
                                  )
                                  .fadeIn(),
                              SizedBox(height: responsive.spacing12),
                              Text(
                                s('chapter_subtitle'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                  textStyle: responsive
                                      .getTextStyle(
                                        size: TextSize.body,
                                        color: Colors.brown.withOpacity(0.8),
                                      )
                                      .copyWith(fontSize: responsive.spacing20),
                                ),
                              ),
                              SizedBox(height: responsive.spacing40),
                              SizedBox(
                                width: responsive.spacing32 * 10, // ~320px to force 3 columns
                                child: Wrap(
                                  spacing: responsive.spacing24,
                                  runSpacing: responsive.spacing32,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(9, (index) {
                                    final chapterNum = index + 1;
                                    return _springChapterButton(
                                      '${s('chapter')} $chapterNum',
                                      Icons.menu_book,
                                      Colors.blue.shade700,
                                      _controllers[index],
                                      chapterNum,
                                      responsive,
                                    ).animate().scale(
                                      delay: Duration(milliseconds: 100 * index),
                                      curve: Curves.elasticOut,
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(height: responsive.spacing40),
                            ],
                          ),
                        ),
                      ),
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

  Widget _springChapterButton(
    String text,
    IconData icon,
    Color color,
    AnimationController controller,
    int chapterNumber,
    ResponsiveHelper responsive,
  ) {
    final isLocked = chapterNumber > _currentUnlockedChapter;
    return GestureDetector(
      onTapDown: isLocked
          ? null
          : (_) => _onChapterPressed(chapterNumber, controller),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.scale(
              scale: isLocked ? 0.95 : 0.95 + (controller.value * 0.15),
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
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
                ),
                Icon(icon, color: Colors.white, size: responsive.iconSizeLarge),
                if (isLocked)
                  Container(
                    width: responsive.spacing32 * 2.2,
                    height: responsive.spacing32 * 2.2,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.22),
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
          ),
          if (isLocked)
            Padding(
              padding: EdgeInsets.only(top: responsive.spacing8),
              child: Text(
                '🔒',
                style: TextStyle(fontSize: responsive.fontSizeSmall),
              ),
            ),
        ],
      ),
    );
  }
}
