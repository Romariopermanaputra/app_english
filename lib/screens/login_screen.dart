import 'package:flutter/material.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _isLoading = false;

  late AnimationController _slideController;
  late Animation<Offset>   _slideAnim;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnim  = CurvedAnimation(parent: _slideController, curve: Curves.easeIn);
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit(String lang) async {
    String s(String key) => AppStrings.get(key, lang);
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    setState(() => _isLoading = true);

    final result = await AuthService().signInWithUsername(username);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      final msg = result.isNewUser ? s('register_success') : s('login_success');
      _showSnack(msg, result.isNewUser ? Colors.blue.shade700 : Colors.green.shade700);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      _showSnack('❌ ${result.error}', Colors.red.shade700);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
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

        return Scaffold(
          body: Stack(
            children: [
              // 🖼️ Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1B5E20)),
                ),
              ),

              // 🌫️ Overlay gradient gelap dari atas ke bawah
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
              ),

              // 📱 KONTEN
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ─── LOGO ─────────────────────────────
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 1.5),
                              ),
                              child: const Text(
                                'ENGLEARN',
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black54, blurRadius: 12)
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Ikon game + subtitle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🎓 ', style: TextStyle(fontSize: 18)),
                                Text(
                                  'Game Edukasi Bahasa Inggris',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 36),

                            // ─── CARD ─────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.96),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Judul
                                    Text(
                                      s('login_title'),
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s('login_subtitle'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // ─── USERNAME FIELD ───────────
                                    TextFormField(
                                      controller: _usernameController,
                                      textCapitalization: TextCapitalization.none,
                                      decoration: InputDecoration(
                                        hintText: s('username_hint'),
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Colors.green.shade700,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade700,
                                              width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 1.5),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return s('username_empty');
                                        }
                                        if (v.trim().length < 3) {
                                          return s('username_short');
                                        }
                                        final valid =
                                            RegExp(r'^[a-zA-Z0-9_]+$');
                                        if (!valid.hasMatch(v.trim())) {
                                          return s('username_invalid');
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 8),

                                    // Hint kecil
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 4),
                                      child: Text(
                                        '💡 Username baru? Akun otomatis dibuat!',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // ─── TOMBOL MULAI ─────────────
                                    SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () => _submit(lang),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 26,
                                                height: 26,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.play_arrow_rounded,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    s('login_btn'),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Hint karakter username
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🔤  Huruf, angka & underscore ( _ )  •  Min. 3 karakter',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
