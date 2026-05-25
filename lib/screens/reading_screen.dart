import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

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
    } else {
      feedback = "wrong";
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
        title: const Text("Reading Practice"),
        backgroundColor: const Color(0xFFFFE66D),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          ProgressBar(
            current: index + 1,
            total: questions.length,
            color: const Color(0xFFFFE66D),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Passage
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Question
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(q['q'] ?? "", textAlign: TextAlign.center),
                  ),

                  const SizedBox(height: 20),

                  // Options
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
                    const SizedBox(height: 20),
                    ActionButton(
                      text: index < questions.length - 1
                          ? "Next Question"
                          : "See Results",
                      onTap: next,
                      color: const Color(0xFFFFB300),
                    ),
                  ],

                  const SizedBox(height: 16),
                  ScoreDisplay(score: score),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
