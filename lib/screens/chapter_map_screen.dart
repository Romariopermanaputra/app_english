import 'package:flutter/material.dart';
import '../screens/level_map_screen.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';

class ChapterMapScreen extends StatefulWidget {
  final int classNumber;

  const ChapterMapScreen({super.key, this.classNumber = 4});

  @override
  State<ChapterMapScreen> createState() => _ChapterMapScreenState();
}

class _ChapterMapScreenState extends State<ChapterMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _chapter1Controller;
  late AnimationController _chapter2Controller;
  late AnimationController _chapter3Controller;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _chapter1Controller = AnimationController(vsync: this, duration: duration);
    _chapter2Controller = AnimationController(vsync: this, duration: duration);
    _chapter3Controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _chapter1Controller.dispose();
    _chapter2Controller.dispose();
    _chapter3Controller.dispose();
    super.dispose();
  }

  void _onChapterPressed(
    int chapterNumber,
    AnimationController controller,
  ) {
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
      );
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
              onPressed: () => Navigator.pop(context),
              tooltip: s('btn_back'),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFFDF5E6),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      s('choose_chapter'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s('chapter_subtitle'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown.withOpacity(0.8),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _springChapterButton(
                          s('chapter_1'),
                          Icons.looks_one,
                          Colors.blue.shade700,
                          _chapter1Controller,
                          1,
                        ),
                        const SizedBox(height: 20),
                        _springChapterButton(
                          s('chapter_2'),
                          Icons.looks_two,
                          Colors.green.shade700,
                          _chapter2Controller,
                          2,
                        ),
                        const SizedBox(height: 20),
                        _springChapterButton(
                          s('chapter_3'),
                          Icons.looks_3,
                          Colors.orange.shade700,
                          _chapter3Controller,
                          3,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                    const Spacer(flex: 2),
                  ],
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
  ) {
    return GestureDetector(
      onTapDown: (_) => _onChapterPressed(chapterNumber, controller),
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
