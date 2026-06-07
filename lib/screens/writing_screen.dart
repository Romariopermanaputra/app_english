import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

// widgets
import '../data/question_data.dart';
import '../widgets/progress_bar.dart';
import '../widgets/feedback_badge.dart';
import '../widgets/action_button.dart';
import '../widgets/score_display.dart';
import '../utils/progress_manager.dart';
import '../utils/score_service.dart';
import '../utils/audio_manager.dart'; // For click sound
import '../widgets/kid_friendly_background.dart';
import 'practice_result_screen.dart';

class WritingScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const WritingScreen({super.key, this.chapter = 1, this.classNumber = 4});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  late final List<Map<String, String>> questions;
  int index = 0;
  int score = 0;
  String feedback = "";
  bool _hasFailedCurrentQuestion = false;

  List<String> _availableWords = [];
  List<String> _selectedWords = [];

  final List<String> _distractors = [
    'is', 'the', 'a', 'to', 'in', 'on', 'my', 'your', 'are', 'he', 'she', 'it', 'do', 'does', 'not', 'and', 'with'
  ];

  @override
  void initState() {
    super.initState();
    questions = QuestionData.writing(widget.classNumber, widget.chapter);
    _loadQuestion();
  }

  void _loadQuestion() {
    String answer = questions[index]['a'] ?? "";
    List<String> answerWords = answer.split(' ').where((w) => w.isNotEmpty).toList();
    
    // Add random distractor words (3 distractors for a bit of challenge)
    final random = Random();
    List<String> pool = List.from(answerWords);
    for (int i = 0; i < 3; i++) {
      pool.add(_distractors[random.nextInt(_distractors.length)]);
    }
    pool.shuffle();

    setState(() {
      _availableWords = pool;
      _selectedWords = [];
      feedback = "";
    });
  }

  void _onWordTapped(String word, bool isSelected) {
    AudioManager().playSfx('click.wav');
    setState(() {
      if (isSelected) {
        // Remove from selected, add back to available
        _selectedWords.remove(word);
        _availableWords.add(word);
      } else {
        // Remove from available, add to selected
        _availableWords.remove(word);
        _selectedWords.add(word);
      }
    });
  }

  void check() {
    if (_selectedWords.isEmpty) return; // Guard clause

    String answer = questions[index]['a'] ?? "";
    String user = _selectedWords.join(" ").toLowerCase().trim();

    if (user == answer) {
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
      _hasFailedCurrentQuestion = false;
      _loadQuestion();
    } else {
      showResultDialog();
    }
    setState(() {});
  }

  void retry() {
    AudioManager().playSfx('click.wav');
    setState(() {
      feedback = "";
      _loadQuestion();
    });
  }

  void showResultDialog() async {
    final maxScore = questions.length * 10;

    ScoreService().saveScore(
      module: 'writing',
      classNumber: widget.classNumber,
      level: 2,
      score: score,
      maxScore: maxScore,
    );

    await ProgressManager.completeLevel(widget.classNumber, 2);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeResultScreen(
            score: score,
            totalQuestions: questions.length,
            classNumber: widget.classNumber,
            levelType: 'writing',
            level: widget.chapter,
          ),
        ),
      );
    }
  }

  Widget _buildWordChip(String word, bool isSelected) {
    return GestureDetector(
      onTap: () => _onWordTapped(word, isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300, 
            width: 3
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.shade100 : Colors.grey.shade300,
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 8),
            Text("Writing Practice", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
      body: KidFriendlyBackground(
        baseColor: Colors.teal,
        child: Column(
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
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFF4ECDC4), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                          blurRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.translate,
                          size: 48,
                          color: Color(0xFF4ECDC4),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Terjemahkan kalimat ini:",
                          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${q['q'] ?? ""}"',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D3748),
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Selected Words (Answer Area)
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 100),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.blue.shade200, width: 3),
                    ),
                    child: _selectedWords.isEmpty
                        ? Center(
                            child: Text(
                              "Ketuk kata di bawah untuk menyusun kalimat",
                              style: TextStyle(color: Colors.blue.shade300, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: _selectedWords
                                .map((word) => _buildWordChip(word, true))
                                .toList(),
                          ),
                  ),

                  const SizedBox(height: 32),

                  // Available Words Pool
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: _availableWords
                        .map((word) => _buildWordChip(word, false))
                        .toList(),
                  ),

                  const SizedBox(height: 32),

                  // Button Check
                  if (feedback.isEmpty)
                    ActionButton(
                      text: "Check Answer",
                      onTap: _selectedWords.isEmpty ? () {} : check,
                      color: _selectedWords.isEmpty ? Colors.grey : const Color(0xFF4ECDC4),
                    ),

                  // Feedback
                  if (feedback.isNotEmpty) ...[
                    FeedbackBadge(isCorrect: feedback == "correct"),
                    const SizedBox(height: 24),
                    
                    if (feedback == "wrong") ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade200, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jawaban yang benar:",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              q['a'] ?? "",
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    ActionButton(
                      text: feedback == "wrong"
                          ? "Coba Lagi 🔄"
                          : (index < questions.length - 1 ? "Next Question" : "See Results"),
                      onTap: feedback == "wrong" ? retry : next,
                      color: feedback == "wrong" ? Colors.red : const Color(0xFF4ECDC4),
                    ),
                    if (feedback == "wrong") ...[
                      const SizedBox(height: 12),
                      ActionButton(
                        text: index < questions.length - 1 ? "Lanjut →" : "See Results 🏆",
                        onTap: next,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ],

                  const SizedBox(height: 24),
                  ScoreDisplay(score: score),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
