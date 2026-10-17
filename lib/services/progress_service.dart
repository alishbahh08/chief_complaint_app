import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/case_progress.dart';
import '../data/cases_data.dart';
import '../data/mcqs_data.dart';

/// A single MCQ attempt: which option the student picked, and whether
/// they've submitted (so the UI can reveal correct/incorrect + explanation).
class McqAttempt {
  int? selected;
  bool submitted;
  McqAttempt({this.selected, this.submitted = false});

  factory McqAttempt.fromJson(Map<String, dynamic> j) =>
      McqAttempt(selected: j['selected'], submitted: j['submitted'] ?? false);
  Map<String, dynamic> toJson() => {'selected': selected, 'submitted': submitted};
}

/// Holds all of the current user's case progress + quiz attempts in memory,
/// mirrored to Firestore under users/{uid}/progress/{caseId} and
/// users/{uid}/quizAttempts/{mcqId} so the dashboard/stats survive reinstalls.
class ProgressService extends ChangeNotifier {
  final Map<String, CaseProgress> _progress = {};
  final Map<String, McqAttempt> _quiz = {};
  bool _loaded = false;

  CaseProgress? progressFor(String caseId) => _progress[caseId];
  McqAttempt attemptFor(String mcqId) => _quiz[mcqId] ??= McqAttempt();

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  CollectionReference<Map<String, dynamic>> get _progressCol =>
      FirebaseFirestore.instance.collection('users').doc(_uid).collection('progress');
  CollectionReference<Map<String, dynamic>> get _quizCol =>
      FirebaseFirestore.instance.collection('users').doc(_uid).collection('quizAttempts');

  Future<void> loadAll() async {
    if (_uid == null) return;
    _progress.clear();
    _quiz.clear();
    final progressSnap = await _progressCol.get();
    for (final doc in progressSnap.docs) {
      _progress[doc.id] = CaseProgress.fromJson(doc.id, doc.data());
    }
    final quizSnap = await _quizCol.get();
    for (final doc in quizSnap.docs) {
      _quiz[doc.id] = McqAttempt.fromJson(doc.data());
    }
    _loaded = true;
    notifyListeners();
  }

  CaseProgress getOrCreate(String caseId) {
    return _progress[caseId] ??= CaseProgress(caseId: caseId);
  }

  Future<void> saveCaseProgress(String caseId) async {
    notifyListeners();
    if (_uid == null) return;
    final p = _progress[caseId];
    if (p == null) return;
    await _progressCol.doc(caseId).set(p.toJson());
  }

  Future<void> saveQuizAttempt(String mcqId) async {
    notifyListeners();
    if (_uid == null) return;
    final a = _quiz[mcqId];
    if (a == null) return;
    await _quizCol.doc(mcqId).set(a.toJson());
  }

  void resetAll() {
    _progress.clear();
    _quiz.clear();
    _loaded = false;
    notifyListeners();
  }

  bool get loaded => _loaded;

  /// Stats shown on the dashboard.
  DashboardStats computeStats() {
    int completed = 0;
    double scoreSum = 0;
    int scoredCount = 0;

    for (final c in allCases) {
      final p = _progress[c.id];
      if (p?.result != null) {
        completed++;
        final examCovered = c.idealExam.where((l) => p!.examOpened.contains(l)).length;
        final ixCovered = c.idealIx.where((l) => p!.ixOpened.contains(l)).length;
        final examScore = (examCovered / c.idealExam.length) * 10;
        final ixScore = (ixCovered / c.idealIx.length) * 10;
        final r = p!.result!;
        final total = ((examScore + ixScore + r.historyScore + r.diagnosisScore + r.rxScore) / 50) * 100;
        scoreSum += total;
        scoredCount++;
      }
    }

    int attempted = 0, correct = 0;
    for (final m in allMcqs) {
      final a = _quiz[m.id];
      if (a != null && a.submitted) {
        attempted++;
        if (a.selected == m.correctIndex) correct++;
      }
    }

    return DashboardStats(
      casesCompleted: completed,
      totalCases: allCases.length,
      avgScore: scoredCount == 0 ? 0 : (scoreSum / scoredCount).round(),
      mcqAttempted: attempted,
      totalMcq: allMcqs.length,
      mcqCorrect: correct,
    );
  }
}

class DashboardStats {
  final int casesCompleted;
  final int totalCases;
  final int avgScore;
  final int mcqAttempted;
  final int totalMcq;
  final int mcqCorrect;

  const DashboardStats({
    required this.casesCompleted,
    required this.totalCases,
    required this.avgScore,
    required this.mcqAttempted,
    required this.totalMcq,
    required this.mcqCorrect,
  });
}
