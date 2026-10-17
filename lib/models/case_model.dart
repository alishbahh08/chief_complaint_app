/// One exam maneuver or investigation: a label the student taps,
/// and the finding/result revealed underneath it.
class CaseItem {
  final String label;
  final String finding;
  const CaseItem(this.label, this.finding);
}

/// One full OPD case: patient info, the AI-roleplay brief, the
/// exam/investigation checklists, and the answer key used for scoring.
class CaseModel {
  final String id;
  final String specialty;
  final String title;
  final String teaser;

  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientOccupation;

  /// If set, this person (e.g. a parent) gives the history instead of
  /// the patient themself — used for young children, unconscious patients, etc.
  final String? informant;

  final Map<String, String> vitals;
  final String opening; // the patient's opening complaint, in their own words
  final String facts; // private case facts the AI patient draws on

  final List<CaseItem> exam;
  final List<String>
      idealExam; // subset of `exam` labels expected to be checked

  final List<CaseItem> investigations;
  final List<String>
      idealIx; // subset of `investigations` labels expected to be ordered

  final String idealDiagnosis;
  final String idealManagement;

  const CaseModel({
    required this.id,
    required this.specialty,
    required this.title,
    required this.teaser,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientOccupation,
    this.informant,
    required this.vitals,
    required this.opening,
    required this.facts,
    required this.exam,
    required this.idealExam,
    required this.investigations,
    required this.idealIx,
    required this.idealDiagnosis,
    required this.idealManagement,
  });
}
