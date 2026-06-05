// File: lib/models/chapter1_question.dart

enum QuestionType { matching, ordering, multipleChoice, fillBlank }

class Chapter1Question {
  final String id;
  final QuestionType type;
  final String title;
  final String instruction;
  final String question;
  final List<String> options;
  final List<String> correctAnswers;
  final String explanation;
  final String? audioRef;

  Chapter1Question({
    required this.id,
    required this.type,
    required this.title,
    required this.instruction,
    required this.question,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
    this.audioRef,
  });
}
