import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/cases_data.dart';
import '../../models/case_model.dart';
import '../../models/case_progress.dart';
import '../../models/chat_message.dart';
import '../../services/ai_service.dart';
import '../../services/progress_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class CaseDetailScreen extends StatefulWidget {
  final String caseId;
  const CaseDetailScreen({super.key, required this.caseId});

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final CaseModel caseModel;
  final ai = AiService();

  @override
  void initState() {
    super.initState();
    caseModel = allCases.firstWhere((c) => c.id == widget.caseId);
    tabController = TabController(length: 6, vsync: this);
  }

  CaseProgress get progress =>
      context.read<ProgressService>().getOrCreate(widget.caseId);

  @override
  Widget build(BuildContext context) {
    context.watch<ProgressService>(); // rebuild on notifyListeners()
    return Scaffold(
      appBar: AppBar(
        title: Text(caseModel.title),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: AppColors.amber,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Examination'),
            Tab(text: 'Investigations'),
            Tab(text: 'Diagnosis'),
            Tab(text: 'Prescription'),
            Tab(text: 'Result'),
          ],
        ),
      ),
      body: Column(
        children: [
          _PatientCard(caseModel: caseModel),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _HistoryTab(caseModel: caseModel, progress: progress, ai: ai),
                _ChecklistTab(
                    items: caseModel.exam,
                    opened: progress.examOpened,
                    kind: 'exam',
                    caseId: widget.caseId),
                _ChecklistTab(
                    items: caseModel.investigations,
                    opened: progress.ixOpened,
                    kind: 'ix',
                    caseId: widget.caseId),
                _DiagnosisTab(progress: progress, caseId: widget.caseId),
                _PrescriptionTab(progress: progress, caseId: widget.caseId),
                _ResultTab(
                    caseModel: caseModel,
                    progress: progress,
                    ai: ai,
                    caseId: widget.caseId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final CaseModel caseModel;
  const _PatientCard({required this.caseModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Color(0x14141E1A), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2)),
            child: Text(caseModel.specialty,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.tealInk, letterSpacing: .5)),
          ),
          const SizedBox(height: 8),
          Text(caseModel.patientName,
              style: Theme.of(context).textTheme.titleMedium),
          Text(
              '${caseModel.patientAge} yrs · ${caseModel.patientGender} · ${caseModel.patientOccupation}',
              style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
          if (caseModel.informant != null)
            Text('Informant: ${caseModel.informant}',
                style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: caseModel.vitals.entries
                .map((e) => Text('${e.key}: ${e.value}',
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12)))
                .toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border.all(color: AppColors.lineSoft),
                borderRadius: BorderRadius.circular(4)),
            child: Text('“${caseModel.opening}”',
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontSize: 13.5, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

/// ---------------- History (AI patient chat) ----------------
class _HistoryTab extends StatefulWidget {
  final CaseModel caseModel;
  final CaseProgress progress;
  final AiService ai;
  const _HistoryTab(
      {required this.caseModel, required this.progress, required this.ai});

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final inputCtrl = TextEditingController();
  late final notesCtrl = TextEditingController(text: widget.progress.notes);
  Timer? _saveTimer;
  bool busy = false;
  bool notesOpen = false;

  @override
  void dispose() {
    _saveTimer?.cancel();
    inputCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  void _onNotesChanged(String v) {
    widget.progress.notes = v;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        context.read<ProgressService>().saveCaseProgress(widget.caseModel.id);
      }
    });
  }

  Future<void> _ask() async {
    final q = inputCtrl.text.trim();
    if (q.isEmpty || busy) return;
    final progressService = context.read<ProgressService>();
    final caseId = widget.caseModel.id;
    inputCtrl.clear();
    setState(() {
      widget.progress.historyLog.add(ChatMessage(ChatRole.user, q));
      busy = true;
    });
    try {
      final reply = await widget.ai.patientReply(
          c: widget.caseModel, history: widget.progress.historyLog);
      widget.progress.historyLog.add(ChatMessage(ChatRole.assistant, reply));
    } catch (e) {
      widget.progress.historyLog.add(const ChatMessage(ChatRole.system,
          'Could not reach the patient right now — try again.'));
    } finally {
      if (mounted) setState(() => busy = false);
      await progressService.saveCaseProgress(caseId);
    }
  }

  Widget _notesPanel() {
    // keep the box in sync if the case was restarted from the Result tab
    if (notesCtrl.text != widget.progress.notes) {
      notesCtrl.text = widget.progress.notes;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => notesOpen = !notesOpen),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.edit_note,
                      size: 18, color: AppColors.tealInk),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('My history notes',
                        style: TextStyle(
                            fontSize: 13.5, fontWeight: FontWeight.w600)),
                  ),
                  if (!notesOpen && widget.progress.notes.trim().isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Text('saved',
                          style:
                              TextStyle(fontSize: 11, color: Colors.black45)),
                    ),
                  Icon(notesOpen ? Icons.expand_less : Icons.expand_more,
                      size: 20),
                ],
              ),
            ),
          ),
          if (notesOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: TextField(
                controller: notesCtrl,
                minLines: 4,
                maxLines: 8,
                onChanged: _onNotesChanged,
                decoration: const InputDecoration(
                  hintText:
                      'Write the history in your own words: presenting complaint, HPI, past/drug/family/social history, red flags... You can edit anytime.',
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: widget.progress.historyLog.length,
            itemBuilder: (_, i) =>
                ChatBubble(message: widget.progress.historyLog[i]),
          ),
        ),
        _notesPanel(),
        if (busy)
          const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Patient is answering…',
                  style:
                      TextStyle(fontStyle: FontStyle.italic, fontSize: 12.5))),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: inputCtrl,
                  decoration: const InputDecoration(
                      hintText: 'e.g. Where exactly does it hurt?'),
                  onSubmitted: (_) => _ask(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: busy ? null : _ask, child: const Text('Ask')),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------- Examination / Investigations ----------------
class _ChecklistTab extends StatefulWidget {
  final List<CaseItem> items;
  final Set<String> opened;
  final String kind; // 'exam' | 'ix'
  final String caseId;
  const _ChecklistTab(
      {required this.items,
      required this.opened,
      required this.kind,
      required this.caseId});

  @override
  State<_ChecklistTab> createState() => _ChecklistTabState();
}

class _ChecklistTabState extends State<_ChecklistTab> {
  @override
  Widget build(BuildContext context) {
    final hint = widget.kind == 'exam'
        ? "Choose which maneuvers you'd like to perform. Tap one to reveal the finding."
        : 'Choose which tests to order. Tap one to reveal the result.';
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Text(hint, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 12),
        ...widget.items.map((item) => ChecklistItem(
              label: item.label,
              finding: item.finding,
              opened: widget.opened.contains(item.label),
              onTap: () {
                setState(() {
                  widget.opened.contains(item.label)
                      ? widget.opened.remove(item.label)
                      : widget.opened.add(item.label);
                });
                context.read<ProgressService>().saveCaseProgress(widget.caseId);
              },
            )),
      ],
    );
  }
}

/// ---------------- Diagnosis ----------------
class _DiagnosisTab extends StatefulWidget {
  final CaseProgress progress;
  final String caseId;
  const _DiagnosisTab({required this.progress, required this.caseId});

  @override
  State<_DiagnosisTab> createState() => _DiagnosisTabState();
}

class _DiagnosisTabState extends State<_DiagnosisTab> {
  late final ctrl = TextEditingController(text: widget.progress.dxText);

  @override
  Widget build(BuildContext context) {
    final submitted = widget.progress.dxSubmitted;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Write your provisional diagnosis and any differentials you are considering.',
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            enabled: !submitted,
            maxLines: 5,
            onChanged: (v) => widget.progress.dxText = v,
            decoration: const InputDecoration(
                hintText: 'Provisional diagnosis and differentials...'),
          ),
          const SizedBox(height: 12),
          if (submitted)
            OutlinedButton(
              onPressed: () =>
                  setState(() => widget.progress.dxSubmitted = false),
              child: const Text('Edit'),
            )
          else
            ElevatedButton(
              onPressed: ctrl.text.trim().isEmpty
                  ? null
                  : () {
                      setState(() => widget.progress.dxSubmitted = true);
                      context
                          .read<ProgressService>()
                          .saveCaseProgress(widget.caseId);
                    },
              child: const Text('Submit diagnosis'),
            ),
        ],
      ),
    );
  }
}

/// ---------------- Prescription ----------------
class _PrescriptionTab extends StatefulWidget {
  final CaseProgress progress;
  final String caseId;
  const _PrescriptionTab({required this.progress, required this.caseId});

  @override
  State<_PrescriptionTab> createState() => _PrescriptionTabState();
}

class _PrescriptionTabState extends State<_PrescriptionTab> {
  late final ctrl = TextEditingController(text: widget.progress.rxText);

  @override
  Widget build(BuildContext context) {
    final submitted = widget.progress.rxSubmitted;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Write your management plan — medicines, fluids, referrals, whatever you would actually order.',
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            enabled: !submitted,
            maxLines: 6,
            onChanged: (v) => widget.progress.rxText = v,
            decoration: const InputDecoration(hintText: 'Management plan...'),
          ),
          const SizedBox(height: 12),
          if (submitted)
            OutlinedButton(
                onPressed: () =>
                    setState(() => widget.progress.rxSubmitted = false),
                child: const Text('Edit'))
          else
            ElevatedButton(
              onPressed: ctrl.text.trim().isEmpty
                  ? null
                  : () {
                      setState(() => widget.progress.rxSubmitted = true);
                      context
                          .read<ProgressService>()
                          .saveCaseProgress(widget.caseId);
                    },
              child: const Text('Submit prescription'),
            ),
        ],
      ),
    );
  }
}

/// ---------------- Result ----------------
class _ResultTab extends StatefulWidget {
  final CaseModel caseModel;
  final CaseProgress progress;
  final AiService ai;
  final String caseId;
  const _ResultTab(
      {required this.caseModel,
      required this.progress,
      required this.ai,
      required this.caseId});

  @override
  State<_ResultTab> createState() => _ResultTabState();
}

class _ResultTabState extends State<_ResultTab> {
  bool loading = false;

  Future<void> _finish() async {
    setState(() => loading = true);
    final progressService = context.read<ProgressService>();
    try {
      final r = await widget.ai.gradeCase(
        c: widget.caseModel,
        history: widget.progress.historyLog,
        notes: widget.progress.notes,
        diagnosis: widget.progress.dxText,
        prescription: widget.progress.rxText,
      );
      if (!mounted) return;
      setState(() => widget.progress.result = r);
      await progressService.saveCaseProgress(widget.caseId);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.progress;
    final c = widget.caseModel;

    if (!p.resultUnlocked) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
              'Submit your diagnosis and prescription first to unlock your result.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54)),
        ),
      );
    }
    if (loading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(24), child: Text('Grading your case…')));
    }
    if (p.result == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ready to see your result?',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
                'This grades your history, diagnosis and prescription with AI feedback, plus your exam/investigation coverage.',
                style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 14),
            ElevatedButton(
                onPressed: _finish,
                child: const Text('Finish case & see result')),
          ],
        ),
      );
    }

    final r = p.result!;
    final examCovered =
        c.idealExam.where((l) => p.examOpened.contains(l)).length;
    final ixCovered = c.idealIx.where((l) => p.ixOpened.contains(l)).length;
    final examScore = (examCovered / c.idealExam.length) * 10;
    final ixScore = (ixCovered / c.idealIx.length) * 10;
    final total =
        ((examScore + ixScore + r.historyScore + r.diagnosisScore + r.rxScore) /
                50) *
            100;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
          children: [
            StatBox(
                value: '${r.historyScore.toStringAsFixed(1)}/10',
                label: 'History'),
            StatBox(
                value: '${examScore.toStringAsFixed(1)}/10',
                label: 'Examination'),
            StatBox(
                value: '${ixScore.toStringAsFixed(1)}/10',
                label: 'Investigations'),
            StatBox(
                value: '${r.diagnosisScore.toStringAsFixed(1)}/10',
                label: 'Diagnosis'),
            StatBox(
                value: '${r.rxScore.toStringAsFixed(1)}/10',
                label: 'Prescription'),
            StatBox(value: '${total.toStringAsFixed(0)}%', label: 'Overall'),
          ],
        ),
        const SizedBox(height: 16),
        _feedbackBlock('History', r.historyFeedback),
        _feedbackBlock('Diagnosis', r.diagnosisFeedback),
        _feedbackBlock('Prescription', r.rxFeedback),
        _feedbackBlock('Overall', r.overallFeedback),
        const SizedBox(height: 8),
        Text('Expected examination: ${c.idealExam.join(', ')}',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text('Expected investigations: ${c.idealIx.join(', ')}',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text('Ideal diagnosis: ${c.idealDiagnosis}',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Text('Ideal management: ${c.idealManagement}',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            setState(() {
              p.historyLog.clear();
              p.notes = '';
              p.examOpened.clear();
              p.ixOpened.clear();
              p.dxText = '';
              p.dxSubmitted = false;
              p.rxText = '';
              p.rxSubmitted = false;
              p.result = null;
            });
            context.read<ProgressService>().saveCaseProgress(widget.caseId);
          },
          child: const Text('Restart this case'),
        ),
      ],
    );
  }

  Widget _feedbackBlock(String title, String text) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColors.paper,
          border: Border(left: BorderSide(color: AppColors.teal, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
            const SizedBox(height: 3),
            Text(text, style: const TextStyle(fontSize: 13.8, height: 1.5)),
          ],
        ),
      );
}
