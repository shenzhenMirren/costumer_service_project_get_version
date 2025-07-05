import 'package:get/get.dart';
import '../models/conversation.dart';
import '../models/sample_data.dart';

class ConversationController extends GetxController {
  var conversations = <Conversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    conversations.addAll(allConversations);
  }

  void addMessage(String name, ChatMessage message) {
    final index = conversations.indexWhere((c) => c.name == name);
    if (index != -1) {
      conversations[index].messages.add(message);
      conversations[index].lastMessage = message.content;
      conversations[index].lastMessageTime = message.time;
      conversations.refresh();
    }
  }
}
