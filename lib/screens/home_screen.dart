import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/audio_manager.dart';
import '../utils/responsive_helper.dart';
import 'leaderboard_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _startController;
  late AnimationController _rankController;
  late AnimationController _settingsController;
  late AnimationController _exitController;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _startController = AnimationController(vsync: this, duration: duration);
    _rankController = AnimationController(vsync: this, duration: duration);
    _settingsController = AnimationController(vsync: this, duration: duration);
    _exitController = AnimationController(vsync: this, duration: duration);
    _playIntroAudio();
  }

  Future<void> _playIntroAudio() async {
    try {
      await AudioManager().playAsset('backsound.mp3');
    } catch (e) {
      debugPrint('⚠️ Gagal memutar backsound: $e');
    }
  }

  @override
  void dispose() {
    _startController.dispose();
    _rankController.dispose();
    _settingsController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String key, AnimationController controller) {
    AudioManager().playSfx('click.wav');
    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (controller.isAnimating || controller.isCompleted) {
          controller.reverse();
        }
      });
    });

    if (key == 'start_game') {
      Navigator.pushNamed(context, '/class-map');
    } else if (key == 'leaderboard') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
      );
    } else if (key == 'settings') {
      Navigator.pushNamed(context, '/settings');
    } else if (key == 'exit') {
      _showExitDialog();
    }
  }

  void _showExitDialog() {
    final lang = AppLanguage().language;
    String s(String key) => AppStrings.get(key, lang);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🚪 ', style: TextStyle(fontSize: 22)),
            Text(
              s('exit_title'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(s('exit_msg')),
        actions: [
          TextButton(
            onPressed: () {
              AudioManager().playSfx('click.wav');
              Navigator.pop(ctx);
            },
            child: Text(
              s('cancel'),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              AudioManager().playSfx('click.wav');
              Navigator.pop(ctx);
              // Keluar dari aplikasi
              SystemNavigator.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              s('exit'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        String s(String key) => AppStrings.get(key, lang);
        final responsive = context.responsive;

        return Scaffold(
          body: Stack(
            children: [
              // 🖼️ BACKGROUND IMAGE
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFFDF5E6)),
                ),
              ),

              // 📱 KONTEN UTAMA
              SafeArea(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing20,
                    vertical: responsive.spacing24,
                  ),
                  children: [
                    SizedBox(height: responsive.spacing40),
                    Text(
                      s('welcome'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        textStyle: responsive.getTextStyle(
                          size: TextSize.heading,
                          color: Colors.brown,
                          weight: FontWeight.bold,
                        ).copyWith(fontSize: responsive.spacing32),
                      ),
                    ),
                    SizedBox(height: responsive.spacing5),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacing24,
                        vertical: responsive.spacing12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.red.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        s('app_title'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          textStyle: responsive.getTextStyle(
                            size: TextSize.xLarge,
                            color: Colors.white,
                            weight: FontWeight.w900,
                            letterSpacing: 2,
                          ).copyWith(fontSize: responsive.spacing40 * 1.2),
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.3))
                     .scaleXY(begin: 1.0, end: 1.05, duration: 1200.ms, curve: Curves.easeInOut),
                    SizedBox(height: responsive.spacing40),
                    Center(
                      child: _springButton(
                        s('start_game'),
                        Icons.play_arrow,
                        Colors.green.shade700,
                        _startController,
                        'start_game',
                      ),
                    ),
                    SizedBox(height: responsive.spacing15),
                    Center(
                      child: _springButton(
                        s('leaderboard'),
                        Icons.leaderboard,
                        Colors.blue.shade700,
                        _rankController,
                        'leaderboard',
                      ),
                    ),
                    SizedBox(height: responsive.spacing15),
                    Center(
                      child: _springButton(
                        s('settings'),
                        Icons.settings,
                        Colors.grey.shade700,
                        _settingsController,
                        'settings',
                      ),
                    ),
                    SizedBox(height: responsive.spacing15),
                    Center(
                      child: _springButton(
                        s('exit'),
                        Icons.exit_to_app,
                        Colors.red.shade700,
                        _exitController,
                        'exit',
                      ),
                    ),
                    SizedBox(height: responsive.spacing40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _springButton(
    String text,
    IconData icon,
    Color color,
    AnimationController controller,
    String key,
  ) {
    return GestureDetector(
      onTapDown: (_) => _onButtonPressed(key, controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Transform.scale(
          scale: 0.95 + (controller.value * 0.15),
          child: child,
        ),
        child: Builder(
          builder: (context) {
            final responsive = context.responsive;
            return Container(
              width: responsive.buttonWidthMedium * 1.2,
              height: responsive.buttonHeight * 1.15,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(responsive.radiusXLarge),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: Offset(0, responsive.spacing8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: responsive.iconSizeMedium * 1.2,
                  ),
                  SizedBox(width: responsive.spacing12),
                  Text(
                    text,
                    style: GoogleFonts.fredoka(
                      textStyle: context.responsive.getTextStyle(
                        size: TextSize.bodyLarge,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ).copyWith(fontSize: responsive.fontSizeBodyLarge * 1.2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
