import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/level_map_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'utils/app_language.dart';
import 'utils/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase — jika URL tidak valid, error ditangkap AuthService
  try {
    await Supabase.initialize(
      url: 'https://haopwrqixplkiulvyqfa.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInNlcnZpY2Vfcm9sZSI6ImhheXB3cnFpeHBsa2l1bHZ5cWZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyOTg3Nn0.99CNkgE-B0aDV_DXw58IE0iJQk8fUaILx_hwXoYHa-I',
    );
  } catch (e) {
    debugPrint('⚠️ Supabase init error: $e');
  }

  await AppLanguage().loadLanguage();

  runApp(const EngLearnApp());
}

class EngLearnApp extends StatelessWidget {
  const EngLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        return MaterialApp(
          title: 'EngLearn',
          debugShowCheckedModeBanner: false,
          locale: Locale(AppLanguage().language),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
          home: const _AuthGate(),
          routes: {
            '/home':      (context) => const HomeScreen(),
            '/level-map': (context) => const LevelMapScreen(),
            '/settings':  (context) => const SettingsScreen(),
            '/login':     (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}

/// AuthGate: cek login via AuthService (Supabase + fallback local).
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1B5E20),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}