import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:convert';

class VerifyDeletePage extends StatefulWidget {
  final String email;
  VerifyDeletePage({required this.email});

  @override
  _VerifyDeletePageState createState() => _VerifyDeletePageState();
}

class _VerifyDeletePageState extends State<VerifyDeletePage> {
  final _codeController = TextEditingController();

  void _verifyAndDeleteAccount() async {
    final email = widget.email;
    final code = _codeController.text;

    // Send request to backend to verify the code and delete the account
    final response = await Api.verifyCodeAndDeleteAccount(email, code);

    if (response.statusCode == 200) {
      // Success: Account deletion
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your account has been successfully deleted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Handle errors
      final responseData = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(responseData['message'] ?? 'Failed to delete the account'),
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
      appBar: AppBar(title: Text('Verify Deletion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Enter your verification code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyAndDeleteAccount,
              child: Text('Verify and Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
