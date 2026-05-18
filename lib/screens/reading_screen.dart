import 'package:flutter/material.dart';

// widgets
import '../widgets/progress_bar.dart';
import '../widgets/feedback_badge.dart';
import '../widgets/action_button.dart';
import '../widgets/score_display.dart';
import '../widgets/option_button.dart';
import '../widgets/result_dialog.dart';
import '../utils/score_service.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final String text =
      "John is a student who loves learning English. Every morning, he wakes up early and reads English books. He believes that practice makes perfect!";

  // 🔥 FIX: kasih tipe jelas
  final List<Map<String, dynamic>> questions = [
    {
      "q": "Who loves learning English?",
      "options": ["John", "Mike", "Sarah", "Tom"],
      "a": "John"
    },
    {
      "q": "What does John do every morning?",
      "options": ["Sleep", "Read", "Play", "Run"],
      "a": "Read"
    },
    {
      "q": "Is John a student?",
      "options": ["Yes", "No", "Maybe", "Unknown"],
      "a": "Yes"
    },
    {
      "q": "When does John wake up?",
      "options": ["Late", "Early", "Noon", "Night"],
      "a": "Early"
    },
    {
      "q": "What does John believe?",
      "options": [
        "Practice makes perfect",
        "Sleep is good",
        "Play is fun",
        "Food is life"
      ],
      "a": "Practice makes perfect"
    },
  ];

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

  void showResultDialog() {
    int correct = score ~/ 10;
    final maxScore = questions.length * 10;

    // Simpan skor ke Supabase
    ScoreService().saveScore(
      module:   'reading',
      level:    1,
      score:    score,
      maxScore: maxScore,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResultDialog(
        correct: correct,
        total: questions.length,
        score: score,
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
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
                    child: Text(
                      q['q'] ?? "",
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Options
                  ...options.map((option) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OptionButton(
                          text: option,
                          isSelected: selectedAnswer == option,
                          isCorrect: feedback.isNotEmpty && option == q['a'],
                          isWrong:
                              feedback == "wrong" && selectedAnswer == option,
                          onTap: feedback.isEmpty ? () => answer(option) : null,
                        ),
                      )),

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
