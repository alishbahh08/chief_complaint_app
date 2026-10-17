enum ChatRole { user, assistant, system }

class ChatMessage {
  final ChatRole role;
  final String text;
  const ChatMessage(this.role, this.text);
}
