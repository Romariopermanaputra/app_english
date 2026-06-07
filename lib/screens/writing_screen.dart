import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../utils/audio_manager.dart';

// widgets
import '../data/question_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/feedback_badge.dart';
import '../widgets/action_button.dart';
import '../widgets/score_display.dart';
import '../widgets/result_dialog.dart';
import '../utils/progress_manager.dart'; // ✅ Import ProgressManager

class WritingScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const WritingScreen({super.key, this.chapter = 1, this.classNumber = 4});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final TextEditingController c = TextEditingController();
  late final List<Map<String, String>> questions;

  @override
  void initState() {
    super.initState();
    questions = QuestionData.writing(widget.classNumber, widget.chapter);
  }

  int index = 0;
  int score = 0;
  String feedback = "";

  void check() {
    String user = c.text.toLowerCase().trim();

    // 🔥 FIX: null safety aman
    String answer = questions[index]['a'] ?? "";

    if (user == answer) {
      feedback = "correct";
      score += 10;
      AudioManager.instance.playCorrectSound();
    } else {
      feedback = "wrong";
      AudioManager.instance.playWrongSound();
    }

    setState(() {});
  }

  void next() {
    if (index < questions.length - 1) {
      index++;
      c.clear();
      feedback = "";
    } else {
      showResultDialog();
    }

    setState(() {});
  }

  // ✅ UPDATED: Menambahkan ProgressManager.completeLevel(2)
  void showResultDialog() {
    int correct = score ~/ 10;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResultDialog(
        correct: correct,
        total: questions.length,
        score: score,
        onClose: () async {
          // 🎯 Simpan progress: Level 2 (Writing) selesai
          await ProgressManager.completeLevel(2);

          debugPrint('✅ Writing Level completed! Progress saved.');

          // Kembali ke LevelMapScreen (pop 2x: dialog + screen)
          if (mounted) {
            Navigator.pop(context); // tutup dialog
            Navigator.pop(context); // kembali ke LevelMapScreen
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    c.dispose(); // 🔥 penting biar tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "✏️ Writing Quiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF50C878),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF0FFF4),
      body: Column(
        children: [
          ProgressBar(
            current: index + 1,
            total: questions.length,
            color: const Color(0xFF50C878),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF50C878), Color(0xFF2E8B57)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '📝 ${index + 1}/${questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '⭐ $score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF66BB6A),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text('✏️', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        const Text(
                          "Type this phrase:",
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${q['q'] ?? ""}"',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: c,
                      decoration: InputDecoration(
                        hintText: "Type your answer here...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (feedback.isEmpty)
                    ActionButton(
                      text: "Check Answer",
                      onTap: check,
                      color: const Color(0xFF4ECDC4),
                    ),

                  if (feedback.isNotEmpty) ...[
                    FeedbackBadge(isCorrect: feedback == "correct"),
                    const SizedBox(height: 16),
                    if (feedback == 'wrong')
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Text(
                          'Jawaban yang benar: ${questions[index]['a'] ?? ''}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ActionButton(
                      text: index < questions.length - 1
                          ? "Next Question"
                          : "See Results",
                      onTap: next,
                      color: const Color(0xFF4ECDC4),
                    ),
                  ],

                  const SizedBox(height: 24),
                  ScoreDisplay(score: score),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
