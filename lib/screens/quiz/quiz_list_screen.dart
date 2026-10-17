import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mcqs_data.dart';
import '../../services/progress_service.dart';
import 'quiz_detail_screen.dart';

class QuizListScreen extends StatelessWidget {
  final String specialty;
  const QuizListScreen({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    final mcqs = allMcqs.where((m) => m.specialty == specialty).toList();
    final progressService = context.watch<ProgressService>();

    return Scaffold(
      appBar: AppBar(title: Text(specialty)),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: mcqs.length,
        itemBuilder: (context, i) {
          final m = mcqs[i];
          final attempt = progressService.attemptFor(m.id);
          Widget? status;
          if (attempt.submitted) {
            final correct = attempt.selected == m.correctIndex;
            status = Text(correct ? 'Correct' : 'Incorrect',
                style: TextStyle(color: correct ? Colors.teal : Colors.red, fontSize: 12, fontFamily: 'monospace'));
          }
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              title: Text('Question ${i + 1}', style: const TextStyle(fontSize: 11, color: Colors.black45, fontFamily: 'monospace')),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(m.question, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500)),
              ),
              trailing: status,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizDetailScreen(mcqId: m.id))),
            ),
          );
        },
      ),
    );
  }
}
