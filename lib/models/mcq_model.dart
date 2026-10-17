class McqModel {
  final String id;
  final String specialty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const McqModel({
    required this.id,
    required this.specialty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
