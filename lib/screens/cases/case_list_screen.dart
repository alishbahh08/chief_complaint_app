import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/cases_data.dart';
import '../../services/progress_service.dart';
import 'case_detail_screen.dart';

class CaseListScreen extends StatelessWidget {
  final String specialty;
  const CaseListScreen({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    final cases = allCases.where((c) => c.specialty == specialty).toList();
    final progressService = context.watch<ProgressService>();

    return Scaffold(
      appBar: AppBar(title: Text(specialty)),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: cases.length,
        itemBuilder: (context, i) {
          final c = cases[i];
          final done = progressService.progressFor(c.id)?.result != null;
          final started = progressService.progressFor(c.id) != null;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              title: Text(c.title, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.teaser, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    if (done) const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('✓ Result recorded', style: TextStyle(fontSize: 11.5, fontFamily: 'monospace', color: Colors.teal)),
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CaseDetailScreen(caseId: c.id))),
                child: Text(started ? 'Continue' : 'Start'),
              ),
            ),
          );
        },
      ),
    );
  }
}
