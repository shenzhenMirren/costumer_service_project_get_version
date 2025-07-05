import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/conversation_controller.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/unlogged_in_home_page.dart';
import 'pages/conversation_list_page.dart';
import 'pages/chat_page.dart';

void main() {
  Get.put(AuthController());
  Get.put(ConversationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My GetX App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/login', page: () =>  LoginPage()),
        GetPage(name: '/register', page: () =>  RegisterPage()),
        GetPage(name: '/conversation', page: () =>  ConversationListPage()),
        GetPage(name: '/chat', page: () =>  ChatPage()),
      ],
      home: Obx(() {
        final auth = Get.find<AuthController>();
        return auth.isLoggedIn.value
            ? const ConversationListPage()
            :  UnloggedInHomePage();
      }),
    );
  }
}
