import 'package:flutter/material.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/auth_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/audio_manager.dart';
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
                    padding: EdgeInsets.symmetric(horizontal: context.responsive.spacing20),
                    child: SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Builder(builder: (context) {
                          final responsive = context.responsive;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ─── LOGO ─────────────────────────────
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.spacing20,
                                  vertical: responsive.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(responsive.radiusLarge),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'ENGLEARN',
                                  style: responsive.getTextStyle(
                                    size: TextSize.largeTitle,
                                    color: Colors.white,
                                    weight: FontWeight.w900,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),

                              SizedBox(height: responsive.spacing10),

                              // Ikon game + subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('🎓 ', style: TextStyle(fontSize: responsive.fontSizeSubtitle)),
                                  Text(
                                    'Game Edukasi Bahasa Inggris',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: responsive.fontSizeBody,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: responsive.spacing32),

                              // ─── CARD ─────────────────────────────
                              Container(
                                padding: EdgeInsets.all(responsive.spacing20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.96),
                                  borderRadius: BorderRadius.circular(responsive.radiusLarge),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 30,
                                      offset: Offset(0, responsive.spacing12),
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
                                        style: responsive.getTextStyle(
                                          size: TextSize.heading,
                                          color: Colors.green.shade800,
                                          weight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: responsive.spacing4),
                                      Text(
                                        s('login_subtitle'),
                                        style: responsive.getTextStyle(
                                          size: TextSize.small,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),

                                      SizedBox(height: responsive.spacing24),

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
                                            borderRadius: BorderRadius.circular(responsive.radiusMedium),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(responsive.radiusMedium),
                                            borderSide: BorderSide(
                                              color: Colors.green.shade700,
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(responsive.radiusMedium),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: responsive.spacing16,
                                            vertical: responsive.spacing16,
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return s('username_empty');
                                          }
                                          if (v.trim().length < 3) {
                                            return s('username_short');
                                          }
                                          final valid = RegExp(r'^[a-zA-Z0-9_]+$');
                                          if (!valid.hasMatch(v.trim())) {
                                            return s('username_invalid');
                                          }
                                          return null;
                                        },
                                      ),

                                      SizedBox(height: responsive.spacing8),

                                      // Hint kecil
                                      Padding(
                                        padding: EdgeInsets.only(left: responsive.spacing4),
                                        child: Text(
                                          '💡 Username baru? Akun otomatis dibuat!',
                                          style: responsive.getTextStyle(
                                            size: TextSize.xSmall,
                                            color: Colors.grey.shade500,
                                            weight: FontWeight.normal,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: responsive.spacing24),

                                      // ─── TOMBOL MULAI ─────────────
                                      SizedBox(
                                        width: double.infinity,
                                        height: responsive.buttonHeight,
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : () {
                                            AudioManager().playSfx('click.wav');
                                            _submit(lang);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(responsive.radiusMedium),
                                            ),
                                            elevation: 4,
                                          ),
                                          child: _isLoading
                                            ? SizedBox(
                                              width: responsive.spacing24,
                                              height: responsive.spacing24,
                                              child: const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                            : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Colors.white,
                                                  size: responsive.iconSizeLarge,
                                                ),
                                                SizedBox(width: responsive.spacing8),
                                                Text(
                                                  s('login_btn'),
                                                  style: responsive.getTextStyle(
                                                    size: TextSize.bodyLarge,
                                                    color: Colors.white,
                                                    weight: FontWeight.bold,
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

                              SizedBox(height: responsive.spacing24),

                              // Hint karakter username
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.spacing12,
                                  vertical: responsive.spacing8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '🔑 Karakter yang diperbolehkan: a-z, A-Z, 0-9, dan _',
                                  style: responsive.getTextStyle(
                                    size: TextSize.small,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        }),
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
