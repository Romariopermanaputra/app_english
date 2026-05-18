import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';

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
    _startController    = AnimationController(vsync: this, duration: duration);
    _rankController     = AnimationController(vsync: this, duration: duration);
    _settingsController = AnimationController(vsync: this, duration: duration);
    _exitController     = AnimationController(vsync: this, duration: duration);
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
    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (controller.isAnimating || controller.isCompleted) {
          controller.reverse();
        }
      });
    });

    if (key == 'start_game') {
      Navigator.pushNamed(context, '/level-map');
    } else if (key == 'settings') {
      Navigator.pushNamed(context, '/settings');
    } else if (key == 'exit') {
      _showExitDialog();
    }
  }

  void _showExitDialog() {
    final lang = AppLanguage().language;
    final s    = (String key) => AppStrings.get(key, lang);

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
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              s('cancel'),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
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
        final s    = (String key) => AppStrings.get(key, lang);

        return Scaffold(
          body: Stack(
            children: [
              // 🖼️ BACKGROUND IMAGE
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFDF5E6)),
                ),
              ),

              // 📱 KONTEN UTAMA
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // 🏷️ JUDUL
                    Column(
                      children: [
                        Text(
                          s('welcome'),
                          style: const TextStyle(
                            fontSize: 26,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          child: Text(
                            s('app_title'),
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // 🔘 TOMBOL MENU
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _springButton(s('start_game'), Icons.play_arrow,   Colors.green.shade700, _startController,    'start_game'),
                        const SizedBox(height: 15),
                        _springButton(s('leaderboard'), Icons.leaderboard, Colors.blue.shade700,  _rankController,     'leaderboard'),
                        const SizedBox(height: 15),
                        _springButton(s('settings'),    Icons.settings,    Colors.grey.shade700,  _settingsController, 'settings'),
                        const SizedBox(height: 15),
                        _springButton(s('exit'),        Icons.exit_to_app, Colors.red.shade700,   _exitController,     'exit'),
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
        child: Container(
          width: 220,
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}