import 'package:flutter/material.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _checkingNumberController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isEmailVerified = false;
  bool _isPasswordMatch = false;
  bool _isEmailValid = false; // 이메일 유효성 상태
  bool _isNumberValid = false; // 체크한 번호 유효성 상태
  String? _selectedNation;

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _verifyEmail() {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email.'); // 이메일이 비어있으면 에러 다이얼로그
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showErrorDialog('Invalid email format.'); // 이메일 형식이 잘못된 경우 에러 다이얼로그
      return;
    }

    setState(() {
      _isEmailValid = true; // 이메일이 유효함
    });
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

  void _showIdentityVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Identity Verification'),
          content: const Text(
            'An identity verification code has been sent to the email address you entered. Please check it and enter it below "Number for Checking Email."',
          ),
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

  void _verifyIdentity() {
    setState(() {
      _isEmailVerified = true; // 이메일이 확인된 것으로 가정
      _showIdentityVerificationDialog(); // 모달창 띄우기
    });
  }

  void _checkVerificationNumber() {
    if (_checkingNumberController.text.isEmpty) {
      _showErrorDialog(
          'Please enter the number sent to your email.'); // 비어있을 때 에러 다이얼로그
      return;
    }

    setState(() {
      _isNumberValid = true; // 번호가 맞다고 가정
      _checkingNumberController.text = ''; // 텍스트 필드 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      enabled: !_isEmailValid, // 이메일이 유효할 때 비활성화
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Email',
                        suffixIcon: Icon(
                          _isEmailValid ? Icons.check_circle : Icons.cancel,
                          color: _isEmailValid ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _verifyEmail,
                      child: const Text('Check for duplicates'),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _isEmailValid ? _verifyIdentity : null,
                      child: const Text('Identity Verification'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    controller: _checkingNumberController,
                    enabled: _isEmailVerified &&
                        !_isNumberValid, // Identity Verification이 되어야 활성화, 체크가 완료된 경우 비활성화
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Number for Checking Email',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNumberValid ? Icons.check_circle : Icons.cancel,
                          color: _isNumberValid ? Colors.green : Colors.red,
                        ),
                        onPressed: null, // 클릭할 필요 없도록 비활성화
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50,
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed:
                          _isEmailVerified ? _checkVerificationNumber : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) => _checkPasswordMatch(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (value) => _checkPasswordMatch(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  suffixIcon: Icon(
                    _isPasswordMatch ? Icons.check_circle : Icons.cancel,
                    color: _isPasswordMatch ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedNation,
                items: <String>['Korea', 'USA', 'Japan', 'China']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNation = newValue;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nation',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isEmailVerified &&
                        _isPasswordMatch &&
                        _firstNameController.text.isNotEmpty &&
                        _lastNameController.text.isNotEmpty &&
                        _selectedNation != null
                    ? () {
                        // Register 버튼 동작
                        // 회원 가입 처리 로직 추가
                      }
                    : null,
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
