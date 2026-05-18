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
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _isLogin      = true;  // true = login, false = register
  bool _isLoading    = false;
  bool _obscurePass  = true;
  bool _obscureConf  = true;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double>  _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideController, curve: Curves.easeIn);
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
    _slideController.reset();
    _slideController.forward();
  }

  Future<void> _submit(String lang) async {
    final s = (String key) => AppStrings.get(key, lang);

    if (!_formKey.currentState!.validate()) return;

    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // ─── LOGIN ───────────────────────────────────────────────────
        final result = await AuthService().signIn(email, password);
        if (!mounted) return;
        if (result.success) {
          _showSnack(s('login_success'), Colors.green.shade700);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else {
          _showSnack('❌ ${result.error}', Colors.red.shade700);
        }
      } else {
        // ─── REGISTER ────────────────────────────────────────────────
        final result = await AuthService().signUp(email, password);
        if (!mounted) return;
        if (result.success) {
          if (result.needsEmailConfirmation) {
            _showSnack(s('register_success'), Colors.blue.shade700);
            setState(() => _isLogin = true);
          } else {
            _showSnack(s('login_success'), Colors.green.shade700);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          }
        } else {
          _showSnack('❌ ${result.error}', Colors.red.shade700);
        }
      }
    } catch (e) {
      if (mounted) _showSnack('❌ $e', Colors.red.shade700);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              // 🖼️ Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ENGLearn.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1B5E20)),
                ),
              ),

              // 🌫️ Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // 📱 KONTEN
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo / Judul App
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: const Text(
                                'ENGLEARN',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black45, blurRadius: 10)
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              '🎓 Game Edukasi Bahasa Inggris',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // ─── CARD LOGIN ──────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Judul Login/Register
                                    Text(
                                      _isLogin
                                          ? s('login_title')
                                          : s('register_title'),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _isLogin
                                          ? s('no_account') + s('register_link')
                                          : s('have_account') + s('login_link'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Email Field
                                    _inputField(
                                      controller: _emailController,
                                      hint: s('email_hint'),
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return s('field_empty');
                                        }
                                        if (!v.contains('@')) return 'Email tidak valid.';
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 14),

                                    // Password Field
                                    _inputField(
                                      controller: _passwordController,
                                      hint: s('password_hint'),
                                      icon: Icons.lock_outline,
                                      obscure: _obscurePass,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePass
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () => setState(
                                            () => _obscurePass = !_obscurePass),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return s('field_empty');
                                        }
                                        if (v.length < 6) return s('password_short');
                                        return null;
                                      },
                                    ),

                                    // Confirm Password (hanya saat register)
                                    if (!_isLogin) ...[
                                      const SizedBox(height: 14),
                                      _inputField(
                                        controller: _confirmController,
                                        hint: s('confirm_password'),
                                        icon: Icons.lock_outline,
                                        obscure: _obscureConf,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConf
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () => setState(
                                              () => _obscureConf = !_obscureConf),
                                        ),
                                        validator: (v) {
                                          if (v != _passwordController.text) {
                                            return s('password_mismatch');
                                          }
                                          return null;
                                        },
                                      ),
                                    ],

                                    const SizedBox(height: 24),

                                    // Tombol Submit
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () => _submit(lang),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : Text(
                                                _isLogin
                                                    ? s('login_btn')
                                                    : s('register_btn'),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Toggle Login/Register
                                    Center(
                                      child: GestureDetector(
                                        onTap: _toggleMode,
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade700),
                                            children: [
                                              TextSpan(
                                                text: _isLogin
                                                    ? s('no_account')
                                                    : s('have_account'),
                                              ),
                                              TextSpan(
                                                text: _isLogin
                                                    ? s('register_link')
                                                    : s('login_link'),
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
