import 'package:flutter/material.dart';
import '../utils/audio_manager.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AudioManager.instance.playClickSound();
        onTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      child: Text(text),
    );
  }
}
