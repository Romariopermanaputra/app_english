import 'package:flutter/material.dart';

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
    } else {
      feedback = "wrong";
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
        title: const Text("Writing Practice"),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          ProgressBar(
            current: index + 1,
            total: questions.length,
            color: const Color(0xFF4ECDC4),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.edit_note,
                          size: 48,
                          color: Color(0xFF4ECDC4),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Write this phrase:",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${q['q'] ?? ""}"',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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

                  // Button Check
                  if (feedback.isEmpty)
                    ActionButton(
                      text: "Check Answer",
                      onTap: check,
                      color: const Color(0xFF4ECDC4),
                    ),

                  // Feedback
                  if (feedback.isNotEmpty) ...[
                    FeedbackBadge(isCorrect: feedback == "correct"),
                    const SizedBox(height: 24),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
