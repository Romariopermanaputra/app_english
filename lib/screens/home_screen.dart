import 'package:flutter/material.dart';

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
    print('🔧 [DEBUG] HomeScreen initialized');
    
    const duration = Duration(milliseconds: 300);
    _startController = AnimationController(vsync: this, duration: duration);
    _rankController = AnimationController(vsync: this, duration: duration);
    _settingsController = AnimationController(vsync: this, duration: duration);
    _exitController = AnimationController(vsync: this, duration: duration);
    
    _debugCheckAsset();
  }

  @override
  void dispose() {
    _startController.dispose();
    _rankController.dispose();
    _settingsController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  // 🔍 Debug helper: cek asset di terminal
  void _debugCheckAsset() {
    print('🔍 [DEBUG] Pastikan:');
    print('   1. File ada di: assets/images/ENGLearn.png');
    print('   2. pubspec.yaml berisi:');
    print('      flutter:');
    print('        assets:');
    print('          - images/ENGLearn.png');
    print('   3. Sudah run: flutter pub get');
  }

  void _onButtonPressed(String name, AnimationController controller) {
    print('👆 [DEBUG] Tombol ditekan: $name');
    
    // Animasi membal
    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 150), () => controller.reverse());
    });
    
    // 🚀 Navigasi logic (nanti diaktifkan)
    if (name == 'START GAME') {
      Navigator.pushNamed(context, '/level-map');
      print('🎮 Buka Level Map / Pilih Modul');
    } else if (name == 'PERINGKAT') {
      // Navigator.pushNamed(context, '/leaderboard');
      print('🏆 Buka Leaderboard');
    } else if (name == 'SETTINGS') {
      // Navigator.pushNamed(context, '/settings');
      print('⚙️ Buka Settings');
    } else if (name == 'KELUAR') {
      print('👋 Keluar dari aplikasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'images/ENGLearn.png',  // ✅ Path sesuai struktur folder kamu
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('❌ [ERROR] Gagal load background: $error');
                return Container(
                  color: const Color(0xFFFDF5E6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image, size: 80, color: Colors.grey),
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
                const Spacer(flex: 1),
                
                // 🏷️ JUDUL
                Column(
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Pacifico',
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
                      child: const Text(
                        "ENGLEARN",
                        style: TextStyle(
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
                    _springButton("START GAME", Icons.play_arrow, Colors.green.shade700, _startController),
                    const SizedBox(height: 15),
                    _springButton("PERINGKAT", Icons.leaderboard, Colors.blue.shade700, _rankController),
                    const SizedBox(height: 15),
                    _springButton("SETTINGS", Icons.settings, Colors.grey.shade700, _settingsController),
                    const SizedBox(height: 15),
                    _springButton("KELUAR", Icons.exit_to_app, Colors.red.shade700, _exitController),
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
  }

  // 🎮 Widget Tombol dengan Animasi Spring
  Widget _springButton(String text, IconData icon, Color color, AnimationController controller) {
    return GestureDetector(
      onTapDown: (_) => _onButtonPressed(text, controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Transform.scale(
          scale: 0.95 + (controller.value * 0.15), // Membesar 15% saat ditekan
          child: child,
        ),
        child: Container(
          width: 220,  // ✅ Compact width
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