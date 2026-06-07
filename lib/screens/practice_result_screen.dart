import 'package:flutter/material.dart';
import 'package:englearn/screens/reading_screen.dart';
import 'package:englearn/screens/writing_screen.dart';
import 'package:englearn/screens/speaking_screen.dart';
import 'package:englearn/screens/leaderboard_screen.dart';
import '../utils/audio_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/kid_friendly_background.dart';

class PracticeResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int classNumber;
  final String levelType; // 'reading', 'writing', 'speaking'
  final int level;

  const PracticeResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.classNumber,
    required this.levelType,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final maxScore = totalQuestions * 10;
    final double percentage = maxScore > 0 ? (score / maxScore) : 0;
    
    String title = "Hebat!";
    String subtitle = "Kamu menyelesaikannya dengan baik!";
    Color accentColor = Colors.green;
    IconData rankIcon = Icons.star_rounded;
    
    if (percentage == 1.0) {
      title = "Sempurna! 🏆";
      subtitle = "Kamu tidak melakukan kesalahan sama sekali!";
      accentColor = Colors.orange;
      rankIcon = Icons.emoji_events_rounded;
    } else if (percentage >= 0.7) {
      title = "Luar Biasa! 🌟";
      subtitle = "Pertahankan prestasimu ya!";
      accentColor = Colors.green;
      rankIcon = Icons.thumb_up_alt_rounded;
    } else if (percentage >= 0.4) {
      title = "Bagus! 👍";
      subtitle = "Tetap semangat belajar ya!";
      accentColor = Colors.blue;
      rankIcon = Icons.check_circle_rounded;
    } else {
      title = "Jangan Menyerah! 💪";
      subtitle = "Ayo coba lagi, kamu pasti bisa!";
      accentColor = Colors.redAccent;
      rankIcon = Icons.local_fire_department_rounded;
    }

    return Scaffold(
      body: KidFriendlyBackground(
        baseColor: accentColor,
        child: Column(
          children: [
            // Header: Icon and Title
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      rankIcon,
                      size: 140,
                      color: accentColor,
                    )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scaleXY(begin: 1.0, end: 1.1, duration: 800.ms, curve: Curves.easeInOut)
                    .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.5)),
                    
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: accentColor.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),

            // Score Board
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: accentColor.withOpacity(0.5), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "TOTAL SKOR",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$score",
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      height: 1.0,
                    ),
                  ).animate()
                   .scaleXY(begin: 0.0, end: 1.0, curve: Curves.elasticOut, duration: 1.seconds)
                   .then(delay: 500.ms)
                   .shimmer(duration: 1.seconds, color: accentColor.withOpacity(0.5)),
                  const SizedBox(height: 4),
                  Text(
                    "dari $maxScore poin",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1.0, end: 0, curve: Curves.easeOutCubic, duration: 600.ms),

            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Selesai Button
                  _buildButton(
                    context: context,
                    text: "Kembali ke Peta",
                    icon: Icons.map,
                    color: Colors.blue,
                    onTap: () {
                      AudioManager().playSfx('click.wav');
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Ulangi Button
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          context: context,
                          text: "Main Lagi",
                          icon: Icons.refresh,
                          color: Colors.orange,
                          onTap: () {
                            AudioManager().playSfx('click.wav');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  if (levelType == 'reading') return ReadingScreen(classNumber: classNumber, chapter: level);
                                  if (levelType == 'writing') return WritingScreen(classNumber: classNumber, chapter: level);
                                  return SpeakingScreen(classNumber: classNumber, chapter: level);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Leaderboard Button
                      Expanded(
                        child: _buildButton(
                          context: context,
                          text: "Peringkat",
                          icon: Icons.emoji_events,
                          color: Colors.purple,
                          onTap: () {
                            AudioManager().playSfx('click.wav');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LeaderboardScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
