import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/shared_widgets.dart';
import '../cases/specialty_list_screen.dart';
import '../quiz/quiz_specialty_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final stats = context.watch<ProgressService>().computeStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chief Complaint'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => context.read<AuthService>().signOut(),
              child: const Text('Log out', style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back, ${auth.displayName}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              const Text('Pick up where you left off, or start something new.',
                  style: TextStyle(color: Colors.black54, fontSize: 13.5)),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  StatBox(value: '${stats.casesCompleted}/${stats.totalCases}', label: 'Cases completed'),
                  StatBox(value: '${stats.avgScore}%', label: 'Avg case score'),
                  StatBox(value: '${stats.mcqAttempted}/${stats.totalMcq}', label: 'MCQs attempted'),
                  StatBox(value: '${stats.mcqCorrect}', label: 'MCQs correct'),
                ],
              ),
              const SizedBox(height: 24),
              DashboardTile(
                emoji: '🩺',
                title: 'Case simulations',
                subtitle: "Take a virtual patient's history, examine, investigate, diagnose and treat.",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialtyListScreen())),
              ),
              const SizedBox(height: 14),
              DashboardTile(
                emoji: '📝',
                title: 'MCQ practice',
                subtitle: 'Subject-wise quizzes with instant explanations and follow-up Q&A.',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizSpecialtyScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
