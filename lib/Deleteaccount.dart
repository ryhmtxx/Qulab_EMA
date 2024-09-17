import 'package:flutter/material.dart';
import 'dart:convert';
import 'api.dart';
import 'VerifyDeletePage.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _emailController = TextEditingController();

  void _sendDeleteCode() async {
    final email = _emailController.text;
    
    // Send request to the backend to send a deletion verification code to the user's email
    final response = await Api.sendDeleteCode(email);
    
    if (response.statusCode == 200) {
      // On success, navigate to the verification code input page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyDeletePage(email: email)),
      );
    } else {
      // Handle errors and display the message returned by the backend
      final responseData = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(responseData['message'] ?? 'Failed to send verification code'),
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
      appBar: AppBar(title: Text('Delete Your Account')),
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
              onPressed: _sendDeleteCode,
              child: Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }
}
