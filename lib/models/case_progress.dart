import 'chat_message.dart';

class GradeResult {
  final double historyScore;
  final String historyFeedback;
  final double diagnosisScore;
  final String diagnosisFeedback;
  final double rxScore;
  final String rxFeedback;
  final String overallFeedback;

  const GradeResult({
    required this.historyScore,
    required this.historyFeedback,
    required this.diagnosisScore,
    required this.diagnosisFeedback,
    required this.rxScore,
    required this.rxFeedback,
    required this.overallFeedback,
  });

  factory GradeResult.fromJson(Map<String, dynamic> j) => GradeResult(
        historyScore: (j['historyScore'] as num?)?.toDouble() ?? 0,
        historyFeedback: j['historyFeedback'] ?? '',
        diagnosisScore: (j['diagnosisScore'] as num?)?.toDouble() ?? 0,
        diagnosisFeedback: j['diagnosisFeedback'] ?? '',
        rxScore: (j['rxScore'] as num?)?.toDouble() ?? 0,
        rxFeedback: j['rxFeedback'] ?? '',
        overallFeedback: j['overallFeedback'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'historyScore': historyScore,
        'historyFeedback': historyFeedback,
        'diagnosisScore': diagnosisScore,
        'diagnosisFeedback': diagnosisFeedback,
        'rxScore': rxScore,
        'rxFeedback': rxFeedback,
        'overallFeedback': overallFeedback,
      };
}

/// Everything the student has done on one case. One of these lives
/// per (user, case) pair and is synced to Firestore.
class CaseProgress {
  final String caseId;
  List<ChatMessage> historyLog;
  String notes;
  Set<String> examOpened;
  Set<String> ixOpened;
  String dxText;
  bool dxSubmitted;
  String rxText;
  bool rxSubmitted;
  GradeResult? result;

  CaseProgress({
    required this.caseId,
    List<ChatMessage>? historyLog,
    this.notes = '',
    Set<String>? examOpened,
    Set<String>? ixOpened,
    this.dxText = '',
    this.dxSubmitted = false,
    this.rxText = '',
    this.rxSubmitted = false,
    this.result,
  })  : historyLog = historyLog ?? [],
        examOpened = examOpened ?? {},
        ixOpened = ixOpened ?? {};

  bool get resultUnlocked => dxSubmitted && rxSubmitted;

  factory CaseProgress.fromJson(String caseId, Map<String, dynamic> j) => CaseProgress(
        caseId: caseId,
        historyLog: (j['historyLog'] as List? ?? [])
            .map((m) => ChatMessage(
                ChatRole.values.firstWhere((r) => r.name == m['role'], orElse: () => ChatRole.system),
                m['text']))
            .toList(),
        notes: j['notes'] ?? '',
        examOpened: Set<String>.from(j['examOpened'] ?? []),
        ixOpened: Set<String>.from(j['ixOpened'] ?? []),
        dxText: j['dxText'] ?? '',
        dxSubmitted: j['dxSubmitted'] ?? false,
        rxText: j['rxText'] ?? '',
        rxSubmitted: j['rxSubmitted'] ?? false,
        result: j['result'] != null ? GradeResult.fromJson(Map<String, dynamic>.from(j['result'])) : null,
      );

  Map<String, dynamic> toJson() => {
        'historyLog': historyLog.map((m) => {'role': m.role.name, 'text': m.text}).toList(),
        'notes': notes,
        'examOpened': examOpened.toList(),
        'ixOpened': ixOpened.toList(),
        'dxText': dxText,
        'dxSubmitted': dxSubmitted,
        'rxText': rxText,
        'rxSubmitted': rxSubmitted,
        'result': result?.toJson(),
      };
}
