import 'package:flutter/material.dart';

class FeedbackBadge extends StatelessWidget {
  final bool isCorrect;

  const FeedbackBadge({super.key, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Text(
      isCorrect ? "Correct!" : "Wrong!",
      style: TextStyle(
        color: isCorrect ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
