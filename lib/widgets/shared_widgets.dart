import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chat_message.dart';

/// One message bubble in the history-taking chat or the MCQ follow-up chat.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.role == ChatRole.system) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(message.text,
              style: const TextStyle(
                  fontSize: 11.5,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic)),
        ),
      );
    }
    final isUser = message.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.teal : AppColors.paper,
          border: isUser ? null : Border.all(color: AppColors.lineSoft),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.ink,
            fontStyle: isUser ? FontStyle.normal : FontStyle.italic,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// A small stat tile for the dashboard ("3/8 cases completed", etc).
class StatBox extends StatelessWidget {
  final String value;
  final String label;
  const StatBox({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 22,
                  color: AppColors.tealInk)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// A big tappable tile on the dashboard ("Case simulations" / "MCQ practice").
class DashboardTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const DashboardTile(
      {super.key,
      required this.emoji,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.panel,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14141E1A), blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              color: AppColors.teal,
              margin: const EdgeInsets.only(right: 14),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 6),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12.5, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A specialty or case row in the stacked picker lists — tappable, with a
/// left accent bar (mirrors the `.spec-card` hover style from the web prototype).
class StackCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  const StackCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.panel,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                  width: 4,
                  height: 40,
                  color: AppColors.teal,
                  margin: const EdgeInsets.only(right: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12.5, color: Colors.black54)),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// An expandable checklist row for the Examination / Investigations tabs.
class ChecklistItem extends StatelessWidget {
  final String label;
  final String finding;
  final bool opened;
  final VoidCallback onTap;
  const ChecklistItem(
      {super.key,
      required this.label,
      required this.finding,
      required this.opened,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.lineSoft),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                      child: Text(label,
                          style: const TextStyle(fontWeight: FontWeight.w500))),
                  if (opened)
                    const Text('✓ viewed',
                        style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: AppColors.teal)),
                ],
              ),
            ),
          ),
          if (opened)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.paper,
                border: Border(top: BorderSide(color: AppColors.lineSoft)),
              ),
              child: Text(finding,
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 13, height: 1.5)),
            ),
        ],
      ),
    );
  }
}
