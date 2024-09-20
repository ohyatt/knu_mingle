import 'package:flutter/material.dart';
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

  void _validateEmail() {
    if (!_idController.text.contains('@')) {
      _showErrorDialog('Invalid email format.'); // 이메일 형식이 잘못된 경우 에러 다이얼로그
    } else {
      _showSuccessDialog(); // 로그인 성공 다이얼로그 표시
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
                width: 350, // 원하는 크기로 조정
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
                          controller: _idController,
                          onChanged: (value) => _checkInput(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
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
                              _validateEmail(); // 이메일 유효성 검사 후 로그인 진행
                            }
                          : null,
                      child: const Text('LOGIN'),
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
                    child: const Text('Find PW'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // User Register 버튼 클릭 시 UserRegisterScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserRegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('User Register'),
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
