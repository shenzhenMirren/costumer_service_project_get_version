class Conversation {
  String name;
  String avatarUrl;
  String lastMessage;
  String deviceInfo;
  bool isOnline;
  DateTime lastMessageTime;
  DateTime? lastSeen;
  List<ChatMessage> messages;

  Conversation({
    required this.name,
    this.avatarUrl = '',
    this.lastMessage = '',
    this.deviceInfo = '',
    this.isOnline = false,
    required this.lastMessageTime,
    this.lastSeen,
    required this.messages,
  });
}

class ChatMessage {
  String content;
  bool isMe;
  bool isRead;
  DateTime time;

  ChatMessage({
    required this.content,
    required this.isMe,
    this.isRead = true,
  }) : time = DateTime.now();
}
