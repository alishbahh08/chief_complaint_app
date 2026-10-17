import 'package:flutter/material.dart';

import '../../data/cases_data.dart';
import '../../widgets/shared_widgets.dart';
import 'case_list_screen.dart';

class SpecialtyListScreen extends StatelessWidget {
  const SpecialtyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final specialties = <String>[];
    for (final c in allCases) {
      if (!specialties.contains(c.specialty)) specialties.add(c.specialty);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a specialty')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: specialties.length,
        itemBuilder: (context, i) {
          final sp = specialties[i];
          final count = allCases.where((c) => c.specialty == sp).length;
          return StackCard(
            title: sp,
            subtitle: '$count case${count == 1 ? '' : 's'} available',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CaseListScreen(specialty: sp)),
            ),
          );
        },
      ),
    );
  }
}
