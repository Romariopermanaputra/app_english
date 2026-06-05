import 'package:flutter/material.dart';
import '../../models/chapter_model.dart';
import 'unit1_get_up_screen.dart';
import 'unit2_time_screen.dart';
import 'chapter1_quiz_screen.dart';

class Chapter1MainScreen extends StatelessWidget {
  final Chapter chapter;

  const Chapter1MainScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 1: My Morning Routine'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Chapter
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chapter.description,
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Unit 1: Get Up!
          _buildUnitCard(
            context,
            title: 'Unit 1: Get Up!',
            subtitle: 'Morning routine vocabulary',
            icon: Icons.wb_sunny,
            color: Colors.blue,
            isUnlocked: true,
            isCompleted: chapter.units[0].isCompleted,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Unit1GetUpScreen()),
            ),
          ),

          const SizedBox(height: 16),

          // Unit 2: Time for School
          _buildUnitCard(
            context,
            title: 'Unit 2: Time for School',
            subtitle: 'Learn to tell time',
            icon: Icons.access_time,
            color: Colors.green,
            isUnlocked: chapter.units[0].isCompleted, // Unlock setelah Unit 1 selesai
            isCompleted: chapter.units.length > 1 ? chapter.units[1].isCompleted : false,
            onTap: chapter.units[0].isCompleted
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Unit2TimeScreen()),
                  )
                : null,
          ),

          const SizedBox(height: 24),

          // Chapter Quiz
          Card(
            color: Colors.orange.shade50,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emoji_events, color: Colors.white, size: 24),
              ),
              title: const Text(
                'Chapter Quiz 🏆',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Test your knowledge!'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              enabled: chapter.units.every((u) => u.isCompleted),
              onTap: chapter.units.every((u) => u.isCompleted)
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Chapter1QuizScreen()),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isUnlocked,
    required bool isCompleted,
    required VoidCallback? onTap,
  }) {
    return Card(
      color: isUnlocked ? color.withOpacity(0.1) : Colors.grey.shade200,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnlocked ? color : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: isUnlocked ? Colors.black54 : Colors.grey),
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
            : isUnlocked
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : const Icon(Icons.lock_outline, size: 20),
        enabled: isUnlocked,
        onTap: onTap,
      ),
    );
  }
}