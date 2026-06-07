import 'package:flutter/material.dart';

// widgets
import '../data/question_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/feedback_badge.dart';
import '../widgets/action_button.dart';
import '../widgets/score_display.dart';
import '../widgets/option_button.dart';
import '../utils/score_service.dart';
import '../utils/progress_manager.dart'; // ✅ Import ProgressManager
import '../utils/audio_manager.dart';
import '../widgets/kid_friendly_background.dart';
import '../widgets/feedback_bottom_panel.dart'; // ✅ Import FeedbackBottomPanel
import 'practice_result_screen.dart';

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
  bool _hasFailedCurrentQuestion = false;

  void answer(String a) {
    selectedAnswer = a;

    String correctAnswer = questions[index]['a'] ?? "";

    if (a == correctAnswer) {
      feedback = "correct";
      if (!_hasFailedCurrentQuestion) {
        score += 10;
      }
    } else {
      feedback = "wrong";
      _hasFailedCurrentQuestion = true;
    }

    setState(() {});
  }

  void next() {
    if (index < questions.length - 1) {
      index++;
      feedback = "";
      selectedAnswer = "";
      _hasFailedCurrentQuestion = false;
    } else {
      showResultDialog();
    }

    setState(() {});
  }

  void retry() {
    AudioManager().playSfx('click.wav');
    setState(() {
      feedback = "";
      selectedAnswer = "";
    });
  }

  // ✅ UPDATED: Menambahkan ProgressManager.completeLevel(1)
  void showResultDialog() async {
    final maxScore = questions.length * 10;

    // Simpan skor ke Supabase
    ScoreService().saveScore(
      module: 'reading',
      classNumber: widget.classNumber,
      level: 1,
      score: score,
      maxScore: maxScore,
    );

    // 🎯 Simpan progress: Level 1 (Reading) selesai → buka Level 2
    await ProgressManager.completeLevel(widget.classNumber, 1);
    debugPrint('✅ Reading Level completed! Progress saved.');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeResultScreen(
            score: score,
            totalQuestions: questions.length,
            classNumber: widget.classNumber,
            levelType: 'reading',
            level: widget.chapter,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    // 🔥 FIX: safe cast
    final List<String> options = List<String>.from(q['options'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, color: Colors.orange),
            SizedBox(width: 8),
            Text("Reading Practice", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFFFFE66D),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: KidFriendlyBackground(
        baseColor: Colors.amber,
        child: Stack(
          children: [
            Column(
              children: [
                ProgressBar(
                  current: index + 1,
                  total: questions.length,
                  color: const Color(0xFFFFE66D),
                ),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Passage
                        Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange.shade200, width: 4),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.2),
                            blurRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "📖 Cerita Kita",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            text,
                            style: const TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF3D2C1E)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.blue.shade200, width: 3),
                      ),
                      child: Text(
                        q['q'] ?? "", 
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueAccent,
                        ),
                      ),
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

                      ScoreDisplay(score: score),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // ─── Duolingo-style Bottom Feedback Panel ───
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: feedback.isNotEmpty ? 0 : -350,
            child: FeedbackBottomPanel(
              feedback: feedback,
              isLastQuestion: index == questions.length - 1,
              correctAnswer: q['a'] ?? "",
              onNext: next,
              onRetry: retry,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
