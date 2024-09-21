import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:knumingle/constants/url.dart';

class FindPwScreen extends StatefulWidget {
  const FindPwScreen({Key? key}) : super(key: key);

  @override
  State<FindPwScreen> createState() => _FindPwScreenState();
}

class _FindPwScreenState extends State<FindPwScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false; // 이메일 유효성 상태

  Future<void> _sendEmail() async {
    String email = _emailController.text;

    // 이메일 형식 검증
    if (!email.contains('@')) {
      _showErrorDialog('Invalid email format.'); // 이메일 형식이 잘못된 경우 에러 다이얼로그
      return;
    }

    // 이메일 전송 로직 (파라미터로 이메일을 보냄)
    final url = '${ApiAddress}/auth/find?email=$email'; // API 주소를 추가하세요
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // 성공적으로 이메일을 보냈을 경우
      _showSuccessDialog(
          'A temporary password has been issued. Please check your email.');
    } else {
      // 실패했을 경우 에러 메시지
      _showErrorDialog('Failed to send email. Please try again.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkEmail() {
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty; // 이메일 입력 여부 확인
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Password',
          style: TextStyle(fontFamily: 'ggsansBold'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: _emailController,
              onChanged: (value) => _checkEmail(), // 이메일이 변경될 때마다 확인
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isEmailValid ? _sendEmail : null, // 이메일이 유효할 때만 활성화
              child: const Text(
                'Send Email',
                style: TextStyle(fontFamily: 'ggsansBold'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
