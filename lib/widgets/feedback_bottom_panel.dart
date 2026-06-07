import 'package:flutter/material.dart';
import '../widgets/action_button.dart';

class FeedbackBottomPanel extends StatelessWidget {
  final String feedback; // "correct", "wrong", or ""
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final bool isLastQuestion;
  final String correctAnswer;

  const FeedbackBottomPanel({
    super.key,
    required this.feedback,
    required this.onRetry,
    required this.onNext,
    required this.isLastQuestion,
    this.correctAnswer = "",
  });

  @override
  Widget build(BuildContext context) {
    if (feedback.isEmpty) return const SizedBox.shrink();

    final isCorrect = feedback == "correct";
    final bgColor = isCorrect ? const Color(0xFFD7FFB8) : const Color(0xFFFFD4D4);
    final textColor = isCorrect ? const Color(0xFF58A700) : const Color(0xFFEA2B2B);
    final buttonColor = isCorrect ? const Color(0xFF58A700) : const Color(0xFFEA2B2B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_rounded : Icons.close_rounded,
                    color: textColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCorrect ? "Benar Sekali! 🎉" : "Kurang Tepat",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (!isCorrect && correctAnswer.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Yang benar:\n$correctAnswer",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isCorrect ? onNext : onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  isCorrect 
                    ? (isLastQuestion ? "SELESAI 🏆" : "LANJUT") 
                    : "COBA LAGI",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: onNext,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isLastQuestion ? "SELESAI 🏆" : "LEWATI SAJA",
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
