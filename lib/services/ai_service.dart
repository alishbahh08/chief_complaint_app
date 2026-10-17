import 'ai_api.dart';

import '../models/case_model.dart';
import '../models/chat_message.dart';
import '../models/case_progress.dart';
import '../models/mcq_model.dart';

/// Every AI call goes through a Cloud Function (see /functions/index.js) â€”
/// never straight to the Anthropic API from the app, so the API key is
/// never shipped to a device. See Module: Backend AI functions.
class AiService {
  Future<String> patientReply(
      {required CaseModel c, required List<ChatMessage> history}) async {
    final result = await AiApi.call('patientReply', {
      'patient': {
        'name': c.patientName,
        'age': c.patientAge,
        'gender': c.patientGender,
        'occupation': c.patientOccupation,
        'informant': c.informant,
      },
      'facts': c.facts,
      'history': history
          .where((m) => m.role != ChatRole.system)
          .map((m) => {'role': m.role.name, 'text': m.text})
          .toList(),
    });
    return result['reply'] as String;
  }

  Future<GradeResult> gradeCase({
    required CaseModel c,
    required List<ChatMessage> history,
    String notes = '',
    required String diagnosis,
    required String prescription,
  }) async {
    final result = await AiApi.call('gradeCase', {
      'idealDiagnosis': c.idealDiagnosis,
      'idealManagement': c.idealManagement,
      'transcript': [
        history
            .where((m) => m.role != ChatRole.system)
            .map((m) => '${m.role.name}: ${m.text}')
            .join('\n'),
        if (notes.trim().isNotEmpty)
          "\nStudent's own written history notes (judge these too):\n${notes.trim()}",
      ].join('\n'),
      'diagnosis': diagnosis,
      'prescription': prescription,
    });
    return GradeResult.fromJson(result);
  }

  Future<String> mcqFollowup({
    required McqModel m,
    required List<ChatMessage> chat,
    required String question,
  }) async {
    final result = await AiApi.call('mcqFollowup', {
      'question': m.question,
      'options': m.options,
      'correctIndex': m.correctIndex,
      'explanation': m.explanation,
      'priorChat':
          chat.map((c) => {'role': c.role.name, 'text': c.text}).toList(),
      'newQuestion': question,
    });
    return result['reply'] as String;
  }
}
