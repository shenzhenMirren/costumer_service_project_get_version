import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnloggedInHomePage extends StatelessWidget {
  const UnloggedInHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('未登录',style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed('/login'),
            child: Text('去登录', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(child: Text('请先登录')),
    );
  }
}
