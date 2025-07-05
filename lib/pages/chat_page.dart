import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/conversation_controller.dart';
import '../models/conversation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _record = AudioRecorder();

  OverlayEntry? _recordOverlay;
  Timer? _timer;
  int _recordDuration = 0;
  bool _isCancel = false;
  late Conversation conversation;

  @override
  void initState() {
    super.initState();
    conversation = Get.arguments as Conversation;
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final newMessage = ChatMessage(content: content, isMe: true);
    Get.find<ConversationController>().addMessage(conversation.name, newMessage);
    _controller.clear();
  }

  Future<void> _pickMedia() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final String ext = file.path.split('.').last.toLowerCase();
    final bool isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
    final bool isVideo = ['mp4', 'mov', 'avi'].contains(ext);

    String type = 'unknown';
    if (isImage) type = 'image';
    if (isVideo) type = 'video';

    final newMessage = ChatMessage(
      content: '[$type] ${file.path}',
      isMe: true,
    );
    Get.find<ConversationController>().addMessage(conversation.name, newMessage);
  }

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      Get.snackbar('无法使用麦克风', '需要麦克风权限');
      return;
    }

    final dir = Directory.systemTemp;
    final path = '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _record.start(
      const RecordConfig(),
      path: path,
    );

    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration++;
      });
    });
    _showRecordOverlay();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _record.stop();

    _hideRecordOverlay();

    if (!_isCancel && path != null) {
      final newMessage = ChatMessage(content: '[voice] $path|$_recordDuration', isMe: true);
      Get.find<ConversationController>().addMessage(conversation.name, newMessage);
    }

    _isCancel = false;
    _recordDuration = 0;
  }

  void _showRecordOverlay() {
    _recordOverlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, size: 64, color: Colors.white),
                Text(
                  '录音中... $_recordDuration 秒',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  '上划取消',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_recordOverlay!);
  }

  void _hideRecordOverlay() {
    _recordOverlay?.remove();
    _recordOverlay = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationController = Get.find<ConversationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(conversation.name, style: const TextStyle(color: Colors.white)),
            Text(
              conversation.isOnline
                  ? '${conversation.deviceInfo} · 在线'
                  : '${conversation.deviceInfo} · 离线 ${_formatTime(conversation.lastSeen ?? DateTime.now())}',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final currentConversation = conversationController.conversations
                  .firstWhere((c) => c.name == conversation.name);

              return ListView.builder(
                itemCount: currentConversation.messages.length,
                itemBuilder: (context, index) {
                  final message = currentConversation.messages[index];
                  final isMe = message.isMe;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(conversation.avatarUrl),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 250),
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Builder(
                            builder: (_) {
                              if (message.content.startsWith('[image] ')) {
                                final path = message.content.replaceFirst('[image] ', '');
                                return Image.file(
                                  File(path),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                );
                              } else if (message.content.startsWith('[video] ')) {
                                final path = message.content.replaceFirst('[video] ', '');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.videocam, size: 48),
                                    Text(
                                      '视频文件: ${path.split('/').last}',
                                      style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              } else if (message.content.startsWith('[voice] ')) {
                                final parts = message.content.replaceFirst('[voice] ', '').split('|');
                                final duration = parts.length > 1 ? parts[1] : '未知';
                                return Row(
                                  children: [
                                    const Icon(Icons.mic, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      '语音: $duration 秒',
                                      style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                GestureDetector(
                  onLongPressStart: (_) async {
                    _isCancel = false;
                    await _startRecording();
                  },
                  onLongPressEnd: (details) async {
                    if (details.localPosition.dy < -50) {
                      _isCancel = true;
                    }
                    await _stopRecording();
                  },
                  onLongPressMoveUpdate: (details) {
                    if (details.localOffsetFromOrigin.dy < -50) {
                      setState(() => _isCancel = true);
                    } else {
                      setState(() => _isCancel = false);
                    }
                  },
                  child: const Icon(Icons.mic),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  onPressed: _pickMedia,
                  icon: const Icon(Icons.photo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
