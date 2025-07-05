import 'conversation.dart';

List<Conversation> allConversations = [
  Conversation(
    name: 'TestUser',
    avatarUrl: 'assets/images/UserImg.jpeg',
    lastMessage: 'Hello',
    deviceInfo: '模拟设备',
    isOnline: true,
    lastMessageTime: DateTime.now(),
    messages: [
      ChatMessage(
        content: 'Hello!',
        isMe: false,
        isRead: true,
      ),
    ],
  ),
  Conversation(
    name: '老飞宇66',
    avatarUrl: 'assets/images/lfy66.png',
    lastMessage: '你好，有什么可以帮您？',
    deviceInfo: 'WLZ-AN00/31/4.0.37',
    isOnline: true,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 1)),
    messages: [
      ChatMessage(content: '你好！', isMe: false),
      ChatMessage(content: '你好，有什么可以帮您？', isMe: true),
    ],
  ),
  Conversation(
    name: '小明',
    avatarUrl: 'assets/images/user1.png',
    lastMessage: '下午见！',
    deviceInfo: 'iPhone 13',
    isOnline: false,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 10)),
    messages: [
      ChatMessage(content: '明天有空吗？', isMe: true),
      ChatMessage(content: '下午见！', isMe: false),
    ],
  ),
  Conversation(
    name: '小红',
    avatarUrl: 'assets/images/user2.png',
    lastMessage: '好的，收到~',
    deviceInfo: 'Android 12',
    isOnline: true,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
    messages: [
      ChatMessage(content: '记得带文件', isMe: true),
      ChatMessage(content: '好的，收到~', isMe: false),
    ],
  ),
  Conversation(
    name: '张三',
    avatarUrl: 'assets/images/user3.png',
    lastMessage: '谢谢你！',
    deviceInfo: 'Windows PC',
    isOnline: false,
    lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
    messages: [
      ChatMessage(content: '文件已发给你', isMe: true),
      ChatMessage(content: '谢谢你！', isMe: false),
    ],
  ),
  Conversation(
    name: '李四',
    avatarUrl: 'assets/images/user4.png',
    lastMessage: '今晚见！',
    deviceInfo: 'MacBook Pro',
    isOnline: true,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
    messages: [
      ChatMessage(content: '几点到？', isMe: false),
      ChatMessage(content: '今晚见！', isMe: true),
    ],
  ),
  Conversation(
    name: '王五',
    avatarUrl: 'assets/images/user5.png',
    lastMessage: '收到！',
    deviceInfo: 'iPad Air',
    isOnline: true,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 2)),
    messages: [
      ChatMessage(content: '请查收邮件', isMe: false),
      ChatMessage(content: '收到！', isMe: true),
    ],
  ),
  Conversation(
    name: '赵六',
    avatarUrl: 'assets/images/user6.png',
    lastMessage: '在路上了',
    deviceInfo: 'Pixel 6',
    isOnline: false,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 20)),
    messages: [
      ChatMessage(content: '快到了吗？', isMe: true),
      ChatMessage(content: '在路上了', isMe: false),
    ],
  ),
  Conversation(
    name: '测试用户9',
    avatarUrl: 'assets/images/user7.png',
    lastMessage: 'OK！',
    deviceInfo: '华为 P50',
    isOnline: true,
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 15)),
    messages: [
      ChatMessage(content: 'assets/images/user7.png', isMe: true),
      ChatMessage(content: 'OK！', isMe: false),
    ],
  ),
];
