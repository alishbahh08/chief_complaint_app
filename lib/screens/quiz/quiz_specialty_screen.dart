import 'package:flutter/material.dart';

import '../../data/mcqs_data.dart';
import '../../widgets/shared_widgets.dart';
import 'quiz_list_screen.dart';

class QuizSpecialtyScreen extends StatelessWidget {
  const QuizSpecialtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final specialties = <String>[];
    for (final m in allMcqs) {
      if (!specialties.contains(m.specialty)) specialties.add(m.specialty);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a specialty')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: specialties.length,
        itemBuilder: (context, i) {
          final sp = specialties[i];
          final count = allMcqs.where((m) => m.specialty == sp).length;
          return StackCard(
            title: sp,
            subtitle: '$count question${count == 1 ? '' : 's'}',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizListScreen(specialty: sp))),
          );
        },
      ),
    );
  }
}
