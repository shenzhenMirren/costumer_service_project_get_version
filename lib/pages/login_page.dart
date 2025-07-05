import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final auth = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,title: Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: 'ID')),
            SizedBox(height: 16),
            TextField(controller: _pwController, decoration: InputDecoration(labelText: '密码')),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
            child:ElevatedButton(
              onPressed: () async {
                final id = _idController.text.trim();
                final pw = _pwController.text.trim();
                final prefs = await SharedPreferences.getInstance();
                final savedId = prefs.getString('saved_id');
                final savedPw = prefs.getString('saved_password');
                if (id == savedId && pw == savedPw) {
                  auth.login();
                  Get.offAllNamed('/');
                } else if(id.isEmpty || pw.isEmpty){
                  Get.snackbar('无法登陆', '账号和密码不能为空');
                } else {
                  Get.snackbar('错误', '账号或密码不正确');
                }
              },
              style:  ElevatedButton.styleFrom(backgroundColor: Colors.blue,),
              child: const Text('登录',style: TextStyle(color: Colors.white,fontSize: 16),),

            ),),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text('没有账号？去注册'),
            ),
          ],
        ),
      ),
    );
  }
}
