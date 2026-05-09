import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;

  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: current / total,
      color: color,
      backgroundColor: color.withOpacity(0.2),
    );
  }
}
