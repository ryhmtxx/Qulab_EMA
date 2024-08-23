import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter_emoji/flutter_emoji.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'VerifyCode.dart';
// import 'RegisterInfo.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void _sendResetCode() async {
    final email = _emailController.text;
    
    // 发送请求到后端，让后端发送重置验证码到用户的邮箱
    final response = await Api.sendResetCode(email);
    
    if (response.statusCode == 200) {
      // 成功后，跳转到验证码输入页面
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyCodePage(email: email)),
      );
    } else {
      // 处理错误，根据后端返回的信息细化提示内容
      final responseData = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(responseData['message'] ?? 'Failed to send reset code'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendResetCode,
              child: Text('Send Reset Code'),
            ),
          ],
        ),
      ),
    );
  }
}
