import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final int correct;
  final int total;
  final int score;
  final VoidCallback onClose;

  const ResultDialog({
    super.key,
    required this.correct,
    required this.total,
    required this.score,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Result"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Correct: $correct / $total"),
          Text("Score: $score"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onClose,
          child: const Text("Close"),
        ),
      ],
    );
  }
}
