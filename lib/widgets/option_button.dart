import 'package:flutter/material.dart';
import '../utils/audio_manager.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    if (isCorrect) {
      bgColor = Colors.green.shade100;
      borderColor = Colors.green;
    } else if (isWrong) {
      bgColor = Colors.red.shade100;
      borderColor = Colors.red;
    } else if (isSelected) {
      bgColor = Colors.blue.shade100;
      borderColor = Colors.blue;
    }

    return GestureDetector(
      onTap: () {
        AudioManager().playSfx('click.wav');
        if (onTap != null) onTap!();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: (isSelected || isCorrect || isWrong)
                  ? borderColor
                  : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
