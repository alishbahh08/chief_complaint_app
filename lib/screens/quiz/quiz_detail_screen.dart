import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mcqs_data.dart';
import '../../models/chat_message.dart';
import '../../models/mcq_model.dart';
import '../../services/ai_service.dart';
import '../../services/progress_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class QuizDetailScreen extends StatefulWidget {
  final String mcqId;
  const QuizDetailScreen({super.key, required this.mcqId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final ai = AiService();
  final chat = <ChatMessage>[];
  final chatCtrl = TextEditingController();
  bool chatBusy = false;

  @override
  Widget build(BuildContext context) {
    final m = allMcqs.firstWhere((x) => x.id == widget.mcqId);
    final progressService = context.watch<ProgressService>();
    final attempt = progressService.attemptFor(widget.mcqId);

    return Scaffold(
      appBar: AppBar(title: const Text('MCQ')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(m.question, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          ...List.generate(m.options.length, (i) {
            Color? borderColor;
            Color? bg;
            if (attempt.submitted) {
              if (i == m.correctIndex) { borderColor = AppColors.teal; bg = AppColors.teal.withValues(alpha: 0.08); }
              else if (i == attempt.selected) { borderColor = AppColors.red; bg = AppColors.red.withValues(alpha: 0.08); }
            } else if (attempt.selected == i) {
              borderColor = AppColors.teal;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: attempt.submitted
                    ? null
                    : () {
                        setState(() => attempt.selected = i);
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor ?? AppColors.lineSoft),
                    color: bg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(String.fromCharCode(65 + i), style: const TextStyle(fontFamily: 'monospace', color: Colors.black45)),
                      const SizedBox(width: 10),
                      Expanded(child: Text(m.options[i])),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (!attempt.submitted)
            ElevatedButton(
              onPressed: attempt.selected == null
                  ? null
                  : () {
                      setState(() => attempt.submitted = true);
                      progressService.saveQuizAttempt(widget.mcqId);
                    },
              child: const Text('Submit answer'),
            ),
          if (attempt.submitted) ...[
            Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.paper,
                border: Border(left: BorderSide(color: AppColors.amber, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explanation', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(m.explanation, style: const TextStyle(height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...chat.map((c) => ChatBubble(message: c)),
            if (chatBusy) const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Text('Thinking…', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.5))),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatCtrl,
                    decoration: const InputDecoration(hintText: 'Ask about this explanation…'),
                    onSubmitted: (_) => _sendFollowup(m),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: chatBusy ? null : () => _sendFollowup(m), child: const Text('Ask')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendFollowup(McqModel m) async {
    final q = chatCtrl.text.trim();
    if (q.isEmpty || chatBusy) return;
    chatCtrl.clear();
    setState(() {
      chat.add(ChatMessage(ChatRole.user, q));
      chatBusy = true;
    });
    try {
      final reply = await ai.mcqFollowup(m: m, chat: chat, question: q);
      setState(() => chat.add(ChatMessage(ChatRole.assistant, reply)));
    } catch (e) {
      setState(() => chat.add(const ChatMessage(ChatRole.system, 'Could not get an answer right now — try again.')));
    } finally {
      setState(() => chatBusy = false);
    }
  }
}
