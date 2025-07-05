import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatelessWidget {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,title: Text('注册')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: 'ID')),
            SizedBox(height: 16),
            TextField(controller: _pwController, decoration: InputDecoration(labelText: '密码')),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 48,
            child:ElevatedButton(
              style:  ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('注册',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                final id = _idController.text.trim();
                final pw = _pwController.text.trim();

                if (id.isEmpty || pw.isEmpty) {
                  Get.snackbar('无法注册', 'ID和密码不能为空',snackPosition: SnackPosition.BOTTOM,);
                  return;
                }
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('saved_id', id);
                await prefs.setString('saved_password', pw);
                Get.snackbar('注册成功', '注册成功，请登录',
                snackPosition:  SnackPosition.BOTTOM,
                duration: const Duration(milliseconds: 750),);
                await Future.delayed(const Duration(milliseconds: 750), (){
                Get.offNamed('/login');
                });
              },
            ),),
          ],
        ),
      ),
    );
  }
}
