import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knumingle/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:knumingle/screens/findpw_screen.dart';
import 'package:knumingle/screens/review_screen.dart';
import 'package:knumingle/screens/userregister_screen.dart'; // UserRegisterScreen import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isOkButtonEnabled = false;

  void _checkInput() {
    setState(() {
      _isOkButtonEnabled =
          _idController.text.isNotEmpty && _pwController.text.isNotEmpty;
    });
  }

  Future<void> _login() async {
    final url = '${ApiAddress}/auth/login'; // ApiAddress 주소로 변경하세요
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _idController.text,
        'password': _pwController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];
      final dynamic userIdValue = responseData['userId'];
      final String userId = userIdValue.toString(); // String으로 변환

      // 로컬 스토리지에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      print(token);
      _showSuccessDialog();
    } else {
      print(response.statusCode);
      _showErrorDialog(
          'Login failed. Please check your Email and PW'); // 로그인 실패 메시지
    }
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
                Navigator.of(context).pop(); // 모달창 닫기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Logged in successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달창 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(),
                  ),
                ); // ReviewPage로 이동
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/login_logo.png', // 이미지 사용
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          style: TextStyle(fontFamily: 'ggsansBold'),
                          controller: _idController,
                          onChanged: (value) => _checkInput(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          style: TextStyle(fontFamily: 'ggsansBold'),
                          controller: _pwController,
                          onChanged: (value) => _checkInput(),
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 128,
                    child: ElevatedButton(
                      onPressed: _isOkButtonEnabled
                          ? () {
                              _login(); // 로그인 메서드 호출
                            }
                          : null,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontFamily: 'ggsansBold'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindPwScreen(),
                          ),
                        );
                      },
                      child: const Text('Find PW',
                          style: TextStyle(fontFamily: 'ggsansBold'))),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserRegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('User Register',
                        style: TextStyle(fontFamily: 'ggsansBold')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
