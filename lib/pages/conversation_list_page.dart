import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/conversation_controller.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({super.key});

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _doNotDisturb = false;

  
  void _toggleMenu(){
    if (_overlayEntry == null) {
      _showMenu();

    }else{
      _removeMenu();
    }
  }

void _showMenu() {
    final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 点击空白区域关闭菜单
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeMenu,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              child: Material(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _doNotDisturb = !_doNotDisturb;
                        });
                        Get.snackbar(
                          '提示',
                          _doNotDisturb ? '已开启勿扰' : '已取消勿扰',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        _removeMenu();
                      },
                      child: Text(_doNotDisturb ? '取消勿扰' : '消息勿扰'),
                    ),
                    TextButton(
                      onPressed: () {
                        final auth = Get.find<AuthController>();
                        auth.logout();
                        Get.snackbar('提示', '已退出登录');
                        _removeMenu();
                      },
                      child: const Text(
                        '退出登录',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
      Overlay.of(context).insert(_overlayEntry!);
}

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }



  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final conversationController = Get.find<ConversationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: GestureDetector(
          key: _menuKey,
          onTap: _toggleMenu,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('接收信息',style: TextStyle(color: Colors.white),),
              Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                '已连接',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final conversations = conversationController.conversations;

        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            final timeString = formatTime(conversation.lastMessageTime);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(conversation.avatarUrl),
                radius: 24,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 名字（蓝色）
                  Text(
                    conversation.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// 最近消息（大且粗）
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 设备信息（最小）
                  Text(
                    conversation.deviceInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                timeString,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              onTap: () {
                Get.toNamed('/chat', arguments: conversation);
              },
            );
          },
        );
      }),
    );
  }

  @override 
  void dispose() {
    _removeMenu();
    super.dispose();
  }
}


