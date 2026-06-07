import 'package:flutter/material.dart';
import '../utils/audio_manager.dart';

// widgets
import '../data/question_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/feedback_badge.dart';
import '../widgets/action_button.dart';
import '../widgets/score_display.dart';
import '../widgets/option_button.dart';
import '../widgets/result_dialog.dart';
import '../utils/score_service.dart';
import '../utils/progress_manager.dart'; // ✅ Import ProgressManager

class ReadingScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const ReadingScreen({super.key, this.chapter = 1, this.classNumber = 4});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late final String text;
  late final List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    text = QuestionData.readingText(widget.classNumber, widget.chapter);
    questions = QuestionData.reading(widget.classNumber, widget.chapter);
  }

  int index = 0;
  int score = 0;
  String feedback = "";
  String selectedAnswer = "";

  void answer(String a) {
    selectedAnswer = a;

    String correctAnswer = questions[index]['a'] ?? "";

    if (a == correctAnswer) {
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
      feedback = "";
      selectedAnswer = "";
    } else {
      showResultDialog();
    }

    setState(() {});
  }

  // ✅ UPDATED: Menambahkan ProgressManager.completeLevel(1)
  void showResultDialog() {
    int correct = score ~/ 10;
    final maxScore = questions.length * 10;

    // Simpan skor ke Supabase
    ScoreService().saveScore(
      module: 'reading',
      level: 1,
      score: score,
      maxScore: maxScore,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResultDialog(
        correct: correct,
        total: questions.length,
        score: score,
        onClose: () async {
          // 🎯 Simpan progress: Level 1 (Reading) selesai → buka Level 2
          await ProgressManager.completeLevel(1);

          debugPrint('✅ Reading Level completed! Progress saved.');

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
  Widget build(BuildContext context) {
    final q = questions[index];

    // 🔥 FIX: safe cast
    final List<String> options = List<String>.from(q['options'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "📖 Reading Quiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF0F7FF),
      body: Column(
        children: [
          ProgressBar(
            current: index + 1,
            total: questions.length,
            color: const Color(0xFF4A90E2),
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
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
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
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF64B5F6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📚 Reading Passage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF263238),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Pertanyaan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q['q'] ?? "",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...options.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OptionButton(
                        text: option,
                        isSelected: selectedAnswer == option,
                        isCorrect: feedback.isNotEmpty && option == q['a'],
                        isWrong:
                            feedback == "wrong" && selectedAnswer == option,
                        onTap: feedback.isEmpty ? () => answer(option) : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

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
                          'Jawaban yang benar: ${q['a'] ?? ''}',
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
                      color: const Color(0xFFFFB300),
                    ),
                  ],

                  const SizedBox(height: 24),
                  ScoreDisplay(score: score),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
